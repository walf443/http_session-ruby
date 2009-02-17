class HTTPSession
  module Store
    class Null
      def initialize
      end

      def select key; end
      def insert key; end
      def update key; end
      def delete key; end
    end
  end
end
