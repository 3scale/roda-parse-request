require 'roda'
require 'roda/parse_request/version'

require 'uri'
require 'json'

class Roda
  module ParseRequest

    OPTS = {}.freeze

    # Set the classes to automatically convert to JSON
    def self.configure(app, opts=OPTS)
      transforms = opts[:parser_transforms] || {
          'application/x-www-form-urlencoded' => ->(data) { URI.decode_www_form(data) },
          'application/json' => ->(data) { JSON.parse(data) }
      }
      app.opts[:parser_transforms] ||= {}
      app.opts[:parser_transforms].merge!(transforms)
      app.opts[:parser_transforms].freeze
    end

    module ClassMethods
      def parser_transforms
        opts[:parser_transforms]
      end
    end

    module RequestMethods
      def parsed_body
        @parsed_body ||= parse_body(body)
      end

      def parse_body(input)
        data = input.read; input.rewind

        return {} if data.nil? || data.empty?

        transforms = roda_class.parser_transforms
        _, transform = transforms.find { |matcher, _transform| matcher === media_type } || Proc.new{ data }

        transform.call(data)
      end
    end
  end

  RodaPlugins.register_plugin(:parse_request, ParseRequest)
end
