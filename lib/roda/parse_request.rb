require 'roda'
require 'roda/parse_request/version'

require 'uri'
require 'json'

class Roda
  module ParseRequest

    OPTS = {}.freeze

    DEFAULT_PARSERS = {
      'application/x-www-form-urlencoded' => ->(data) { URI.decode_www_form(data) },
      'application/json' => ->(data) { JSON.parse(data) }
    }.freeze

    IDENTITY_PARSER = (->(data) { data }).freeze

    # Set the classes to automatically convert to JSON
    def self.configure(app, opts=OPTS)
      parsers = DEFAULT_PARSERS.merge(opts[:parsers] || {})
      app.opts[:parse_request_parsers] ||= parsers
      app.opts[:parse_request_parsers].freeze
    end

    module ClassMethods
      def parse_request_parsers
        opts[:parse_request_parsers]
      end
    end

    module RequestMethods
      def parsed_body
        @parsed_body ||= parse_body(body)
      end

      private

      def parse_body(input)
        data = input.read; input.rewind

        parser = roda_class.parse_request_parsers[media_type] || IDENTITY_PARSER

        parser.call(data)
      end
    end
  end

  RodaPlugins.register_plugin(:parse_request, ParseRequest)
end
