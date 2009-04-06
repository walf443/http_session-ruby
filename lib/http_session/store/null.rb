class HTTPSession
  module Store
    class Null
      def initialize
      end

      def select key; end
      def insert key, val; end
      def update key, val; end
      def delete key; end
    end
  end
end
