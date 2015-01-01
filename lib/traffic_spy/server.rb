require 'json'
module TrafficSpy
  class Server < Sinatra::Base
    set :views, 'lib/views'

    get '/' do
      erb :index
    end

    post '/sources' do
      status Identifier.register(params)[:status]
      body Identifier.register(params)[:body]
    end

    post '/sources/:identifier/data' do
      status_message = Payload.create(params)
      status status_message[:status]
      body status_message[:body]
    end

    not_found do
      erb :error
    end
  end
end
