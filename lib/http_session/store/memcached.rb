
class HTTPSession
  module Store
    class Memcached
      def initialize hash
        @memd = hash[:memd] or
          raise "memd is not found"

        @expires = hash[:expires] || 0
      end

      def select session_id
        @memd.get(session_id)
      end

      def insert session_id, value
        @memd.set(session_id, value, @expires)
      end

      def update session_id, value
        @memd.replace(session_id, value, @expires)
      end

      def delete session_id
        @memd.delete(session_id)
      end
    end
  end
end
