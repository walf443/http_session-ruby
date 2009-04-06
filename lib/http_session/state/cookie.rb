class HTTPSession
  module State
    class Cookie
      attr_reader :name, :path, :domain, :expires

      def initialize hash={}
        @name = hash[:name] ? hash[:name] : 'http_session_sid'
        @path = hash[:path] ? hash[:path] : '/'
        @domain = hash[:domain] 
        @expires = hash[:expires]
      end

      def permissive?
        false
      end

      def get_session_id req
        cookie = req.cookies
        cookie[@name]
      end

      def response_filter session_id, res
        header_filter(session_id, res)
      end

      def header_filter session_id, res
        cookie = {
          :path   => @path,
          :value  => session_id,
        }
        cookie[:domain] = @domain if @domain
        cookie[:expires] = @expires if @expires

        res.set_cookie(@name, cookie)
      end
    end
  end
end
