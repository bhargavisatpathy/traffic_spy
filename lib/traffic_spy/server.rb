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
      identifier_id = DB.from(:identifiers).select(:id).where(:identifier => params["identifier"]).to_a[0][:id]
      temp = DB .from(:payloads)
                .where(:identifier_id => identifier_id)
                .join(:urls, :id => :url_id)
                .group_and_count(:url)
                .order(Sequel.desc(:count)).to_a
                .map { |entry| [entry[:url],entry[:count]] }

      puts temp.inspect
      erb :display, locals: {temp: temp}
    end


    not_found do
      erb :error
    end
  end
end
