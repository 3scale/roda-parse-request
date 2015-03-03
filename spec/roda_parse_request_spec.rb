require 'spec_helper'

RSpec.describe Roda::ParseRequest do

  context "default parsers" do

    let(:app) do
      Class.new(Roda) do
        plugin :parse_request

        route do |r|
          r.post do
            request.parsed_body.to_json
          end
        end
      end.app.freeze
    end

    it 'parses json' do
      post '/', '{"valid":true}', 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('{"valid":true}')
    end

    it 'parses urlencoded' do
      post '/', 'a=b&c=d', 'CONTENT_TYPE' => 'application/x-www-form-urlencoded'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('[["a","b"],["c","d"]]')
    end

    it 'works when no parser is found' do
      post '/', 'hello', 'CONTENT_TYPE' => 'something/not-expected'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('"hello"')
    end

  end

  context "custom parsers" do
    let(:app) do
      Class.new(Roda) do
        plugin :parse_request, parsers: {
          'hodor'            => ->(data) { 'hodor' },
          'upcase'           => ->(data) { data.upcase },
          'application/json' => ->(data) { '<xml>troll</xml>' }
        }

        route do |r|
          r.post do
            request.parsed_body.to_json
          end
        end
      end.app.freeze
    end

    it 'works with the simplest case' do
      post '/', 'hey', 'CONTENT_TYPE' => 'hodor'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('"hodor"')
    end

    it 'can access the data' do
      post '/', 'hey', 'CONTENT_TYPE' => 'upcase'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('"HEY"')
    end

    it 'can use the default parsers' do
      post '/', 'a=b&c=d', 'CONTENT_TYPE' => 'application/x-www-form-urlencoded'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('[["a","b"],["c","d"]]')
    end

    it 'can override default parsers' do
      post '/', '{"valid":true}', 'CONTENT_TYPE' => 'application/json'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('"<xml>troll</xml>"')
    end

  end


end
