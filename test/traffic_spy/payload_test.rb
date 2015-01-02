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

    def test_save_payload_saves_a_payload
    
    end

  end
end
