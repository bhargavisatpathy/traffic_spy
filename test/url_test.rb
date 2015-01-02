require_relative 'test_helper'

module TrafficSpy

  class ServerTest < Minitest::Test
    include Rack::Test::Methods

    def app
      Server
    end

    def teardown
      DB[:urls].delete
      DB[:payloads].delete
      DB[:identifiers].delete
    end

  end
end

