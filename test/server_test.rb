require_relative 'test_helper'

module TrafficSpy

  class ServerTest < Minitest::Test
    include Rack::Test::Methods
    # include Capybara::DSL

    def app
      # Capybara.app = Sinatra::Application.new
      Server
    end

    def teardown
      DB[:identifiers].delete
      DB[:payloads].delete
      DB[:resolutions].delete
      DB[:urls].delete
      DB[:event_names].delete
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

    def test_post_sources_identifier_does_not_save_a_duplicate_payload
      skip
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      post '/sources/jumpstartlab/data',
      "payload={\"url\":\"h\",\"requestedAt\":\"cheese\",\"respondedIn\":37,\"referredBy\":\"fries\",
      \"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"frog\",\"userAgent\":\"Mozilla/5.0\",
      \"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
      post '/sources/jumpstartlab/data',
      "payload={\"url\":\"h\",\"requestedAt\":\"cheese\",\"respondedIn\":37,\"referredBy\":\"fries\",
      \"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"frog\",\"userAgent\":\"Mozilla/5.0\",
      \"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
      assert_equal 403, last_response.status
      assert_equal "Already received request", last_response.body
    end

    def test_get_sources_identifier_displays_resolution
      skip
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      post '/sources/jumpstartlab/data',
      "payload={\"url\":\"h\",\"requestedAt\":\"cheese\",\"respondedIn\":37,\"referredBy\":\"fries\",
      \"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"frog\",\"userAgent\":\"Mozilla/5.0\",
      \"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
      get '/sources/jumpstartlab'
      assert_equal 200, last_response.status
      # within("#resolution_width") do
      #    assert has_css?("Width: 1920, ")
      # end
    end

    def test_get_sources_identifier_events_displays_events_index
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      post '/sources/jumpstartlab/data',
      "payload={\"url\":\"h\",\"requestedAt\":\"cheese\",\"respondedIn\":37,\"referredBy\":\"fries\",
      \"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"frog\",\"userAgent\":\"Mozilla/5.0\",
      \"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
      get '/sources/jumpstartlab/events'
      assert_equal 200, last_response.status
    end

    def test_get_sources_identifier_events_does_not_display_events
      skip
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      post '/sources/jumpstartlab/data',
      "payload={\"url\":\"h\",\"requestedAt\":\"cheese\",\"respondedIn\":37,\"referredBy\":\"fries\",
      \"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"" "\",\"userAgent\":\"Mozilla/5.0\",
      \"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
      get '/sources/jumpstartlab/events'
      assert_equal 200, last_response.status
      assert_equal "No events defined", last_response.body
    end
  end
end
