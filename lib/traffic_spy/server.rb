require 'json'
module TrafficSpy
  class Server < Sinatra::Base
    set :views, 'lib/views'

    get '/' do
      erb :index
    end

    post '/sources' do
      if Identifier.missing_identifier?(params)
        status 400
        body "Missing parameters\n"
      elsif Identifier.exists?(params["identifier"])
        status 403
        body "Identifier already exists\n"
      else
        Identifier.save_identifier(params)
        status 200
        body "Success " + {identifier: params["identifier"]}.to_json + "\n"
      end
    end

    post '/sources/:identifier/data' do
      if Payload.missing_payload?(params["payload"])
        status 400
        body "Missing Payload"
      elsif !Identifier.exists?(params["identifier"])
        status 403
        body "Application Not Registered"
      else
        Payload.save_payload(Payload.to_hash(params["payload"]), params["identifier"])
        status 200
      end
    end

    not_found do
      erb :error
    end
  end
end
