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

    def test_identifier_page_protected
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      get "/sources/jumpstartlab"
      assert_equal 401, last_response.status
    end

    def test_identifier_page_for_bad_credentials
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      get "/sources/jumpstartlab"
      authorize 'user', 'worngpassword'
      get "/sources/jumpstartlab"
      assert_equal 401, last_response.status
    end

    def test_url_page_protected
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      get "/sources/jumpstartlab/urls/blog"
      assert_equal 401, last_response.status
    end

    def test_url_page_for_bad_credentials
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      get "/sources/jumpstartlab/urls/blog"
      authorize 'user', 'worngpassword'
      get "/sources/jumpstartlab/urls/blog"
      assert_equal 401, last_response.status
    end

    def test_event_name_page_protected
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      get "/sources/jumpstartlab/events/socialLogin"
      assert_equal 401, last_response.status
    end

    def test_url_page_for_bad_credentials
      post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
      get "/sources/jumpstartlab/events/socialLogin"
      authorize 'user', 'worngpassword'
      get "/sources/jumpstartlab/events/socialLogin"
      assert_equal 401, last_response.status
    end

    # def test_identifier_page_for_right_credentials
    #   skip
    #   post '/sources', 'identifier=jumpstartlab&rootUrl=http://jumpstartlab.com'
    #   get "/sources/jumpstartlab"
    #   authorize 'admin', 'admin'
    #   get "/sources/jumpstartlab"
    #   assert_equal 200, last_response.status
    # end

  end
end
