require 'faraday'
require 'json'
require 'recursive-open-struct'
require 'smartsheet/api/faraday_adapter/faraday_response'

module Smartsheet
  module API
    module Middleware
      class ResponseParser < Faraday::Middleware
        def initialize(app)
          super(app)
        end

        def call(env)
          @app.call(env).on_complete do |response_env|
            if response_env[:response_headers]['content-type'] =~ /\bjson\b/
              response_env[:body] = JSON.parse(response_env[:body])
            end

            response_env[:body] = FaradayResponse.from_response_env response_env
          end
        end
      end
    end
  end
end