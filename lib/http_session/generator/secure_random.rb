require 'securerandom'

class HTTPSession
  module Generator
    module SecureRandom
      def generate length
        ::SecureRandom.hex(length)
      end
      module_function :generate
    end
  end
end
