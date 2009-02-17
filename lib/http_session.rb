# Extensible Session Manager for Web Service.
class HTTPSession
  attr_reader :store, :state, :env

  def initialize hash

    @store = hash[:store] or
      raise ':store missing'
    @state = hash[:state] or
      raise ':state missing'
    @env = hash[:env] or
      raise ':env missing'

    @data = {}
    @sid_length = hash[:sid_length] || 30
    # XXX: SecureRandom is missing on ruby 1.8.x
    @generator = hash[:generator] || HTTPSession::Generator::SecureRandom
  end

  def _load_session
    session_id = @state.get_session_id
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

  # some environment can't use Cookie. for example, some japanese mobile phone.( DoComo )
  # So, custarmize html by user to identify.
  def response_filter res
    @state.response_filter(@session_id, res)
  end

  # namespace for session_id generator
  module Generator
    autoload :SecureRandom, 'http_session/generator/secure_random'
  end

  # namespace for control session state
  module State
    autoload :Null, 'http_session/state/null'
    autoload :MobileID, 'http_session/state/mobile_id'
  end

  # namespace for session strage
  module Store
    autoload :Null, 'http_session/store/null'
  end
end

