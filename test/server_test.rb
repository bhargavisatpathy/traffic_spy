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

  end
end
