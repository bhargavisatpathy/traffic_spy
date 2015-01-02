require 'json'
module TrafficSpy
  class Server < Sinatra::Base
    set :views, 'lib/views'

    get '/' do
      erb :index
    end

    post '/sources' do
      status_message = Identifier.register(params)
      status status_message[:status]
      body status_message[:body]
    end

    post '/sources/:identifier/data' do
      status_message = Payload.create(params)
      status status_message[:status]
      body status_message[:body]
    end

    get '/sources/:identifier' do
      rankurl = Url.rankurl(params[:identifier])

      resolution = Resolution.display_resolution(params[:identifier])
      erb :display, locals: {rankurl: rankurl, resolution: resolution}
    end

    not_found do
      erb :error
    end
  end
end
