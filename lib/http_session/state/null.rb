class HTTPSession
  module State
    class Null
      def permissive?
        false
      end

      def get_session_id
      end

      def response_filter
      end

    end
  end
end
