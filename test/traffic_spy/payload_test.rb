require_relative '../test_helper'

module TrafficSpy
  class PayloadTest < Minitest::Test
    include Rack::Test::Methods

    def app
      Server
    end

    def teardown
      DB[:payloads].delete
    end

  end
end
