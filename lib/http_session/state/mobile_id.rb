class HTTPSession
  module State
    class MobileID
      class InvalidIPError < Exception; end
      class NoMobileIDError < Exception; end

      def initialize hash
        @mobile = hash[:mobile] or
          raise 'mising :mobile'

        @check_ip = hash[:check_ip] || true
        @permissive = hash[:check_ip].nil? ? true : hash[:check_ip]
      end

      def permissive?
        !!@permissive
      end

      def get_session_id
        if @mobile.ident
          if @check_ip
            unless @mobile.valid_ip?
              raise InvalidIPError
            end
          end
          return @mobile.ident
        else
          raise NoMobileIDError
        end
      end

      def response_filter res
      end
    end
  end
end
