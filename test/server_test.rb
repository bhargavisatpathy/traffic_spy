require_relative 'test_helper'
require 'minitest/pride'

module TrafficSpy

  class ServerTest < Minitest::Test
    include Rack::Test::Methods

    def app
      Server
    end

    def teardown
      DB[:identifiers].delete
    end

    def test_post_sources_for_missing_parameters
      post '/sources', 'identifier=hotmail'
      assert_equal 400, last_response.status
    end

    def test_post_sources_for_identifier_already_exists
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      post '/sources', 'identifier=google&rootUrl=http://google.com'
      assert_equal 200, last_response.status

      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      assert_equal 403, last_response.status
    end

    def test_post_sources_for_success
      post '/sources', 'identifier=turing&rootUrl=http://turing.com'
      assert_equal 200, last_response.status
      assert_equal "Success {\"identifier\":\"turing\"}\n", last_response.body
    end

    def test_post_sources_identifier_has_a_missing_payload
      post '/sources/jumpstartlab/data', '" " http://localhost:9393/sources/jumpstartlab/data'
      assert_equal 400, last_response.status
      assert_equal "Missing Payload", last_response.body
    end

    def test_post_sources_identifier_not_registered
      post '/sources/as/data','payload={}'
      assert_equal 403, last_response.status
      assert_equal "Application Not Registered", last_response.body
    end

    def test_post_sources_identifier_for_success
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      post '/sources/jumpstartlab/data',
      "payload={\"url\":\"h\",\"requestedAt\":\"cheese\",\"respondedIn\":37,\"referredBy\":\"fries\",
      \"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"frog\",\"userAgent\":\"Mozilla/5.0\",
      \"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
      assert_equal 200, last_response.status
    end

    def test_post_sources_identifier_is_saving_payload
      
    end
  end
end
