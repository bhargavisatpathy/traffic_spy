module TrafficSpy

  # Sinatra::Base - Middleware, Libraries, and Modular Apps
  #
  # Defining your app at the top-level works well for micro-apps but has
  # considerable drawbacks when building reusable components such as Rack
  # middleware, Rails metal, simple libraries with a server component, or even
  # Sinatra extensions. The top-level DSL pollutes the Object namespace and
  # assumes a micro-app style configuration (e.g., a single application file,
  # ./public and ./views directories, logging, exception detail page, etc.).
  # That's where Sinatra::Base comes into play:
  #
  class Server < Sinatra::Base
    set :views, 'lib/views'

    get '/' do
      erb :index
    end

    post '/sources' do

      if params["identifier"].nil? || params["rootUrl"].nil?
        status 400
        body "Missing parameters"
      else
        DB.from(:identifiers).insert(:identifier => params["identifier"], :rooturl => params["rootUrl"])
        status 200
        body "Success"
      end
    end

    not_found do
      erb :error
    end
  end

end
