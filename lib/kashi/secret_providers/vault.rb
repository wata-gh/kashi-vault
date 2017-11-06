require 'kashi'
require 'vault'
require 'vault/errors'

module Kashi
  module SecretProviders
    class Vault
      def initialize
      end

      def ask(keys)
        result = {}
        keys.each do |key|
          begin
            result[key] = ::Vault.get("v1/secret/#{key}")[:data][:value]
          rescue ::Vault::HTTPClientError => e
            if e.code == 404
              Kashi.logger.info("[#{self.class}] key not found. => `#{key}`")
            end
            raise e
          end
        end
        result
      end
    end
  end
end
