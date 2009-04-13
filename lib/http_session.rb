# Extensible Session Manager for Web Service.
class HTTPSession
  attr_reader :store, :state, :request, :is_changed, :is_fresh

  def initialize hash

    @store = hash[:store] or
      raise ':store missing'
    @state = hash[:state] or
      raise ':state missing'
    @request = hash[:request] or
      raise ':request missing'

    @data = {}
    @sid_length = hash[:sid_length] || 30
    # XXX: SecureRandom is missing on ruby 1.8.x
    @generator = hash[:generator] || HTTPSession::Generator::SecureRandom
  end

  def setup
    _load_session
  end

  def _load_session
    session_id = @state.get_session_id @request
    if session_id
      data = @store.select(session_id)
      if data
        @session_id = session_id
        @data = data
      else
        if @state.permissive?
          @session_id = session_id
          @is_fresh = true
        else
          # session was expired ?
          @session_id = _generate_session_id
          @is_fresh = true
        end
      end
    else
      @session_id = _generate_session_id
      @is_fresh = true
    end
  end

  def _generate_session_id
    @generator.generate(@sid_length)
  end

  def response_filter res
    @state.response_filter(@session_id, res)
  end

  def finalize
    if @is_fresh
      @store.insert(@session_id, @data)
    else
      if @is_changed
        @store.update(@session_id, @data)
      end
    end
  end

  def keys
    @data.keys
  end

  def get key
    @data[key]
  end

  alias [] get

  def set key, val
    @is_changed = true
    @data[key] = val
  end

  alias []= set

  def remove key
    @is_changed = true
    @data.delete key
  end

  def to_hash
    @data.dup
  end

  def expire
    @store.delete(@session_id)
    @expired = true
  end

  %w[ redirect_filter header_filter html_filter ].each do |meth|
    define_method meth do |res|
      if @state.respond_to? meth
        @state.__send__ meth, @session_id, res
      else
        res
      end
    end
  end

  # namespace for session_id generator
  module Generator
    autoload :SecureRandom, 'http_session/generator/secure_random'
  end

  # namespace for control session state
  module State
    autoload :Null, 'http_session/state/null'
    autoload :MobileID, 'http_session/state/mobile_id'
    autoload :Cookie, 'http_session/state/cookie'
  end

  # namespace for session strage
  module Store
    autoload :Null, 'http_session/store/null'
    autoload :Memcached, 'http_session/store/memcached'
  end
end

