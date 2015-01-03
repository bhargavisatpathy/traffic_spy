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
      id                 = Identifier.get_id(params[:identifier])
      @rank_url          = Url.rank_url(id)
      @rank_browser      = Agent.rank_browser(id)
      @rank_os           = Agent.rank_os(id)
      @resolution        = Resolution.display_resolution(id)
      @avg_response_time = Url.rank_url_by_reponse_time(id)
      erb :display
    end

    get '/test/:identifier' do
      id = Identifier.get_id(params[:identifier])
      UserAgent.browser_rank(id)
    end

    get '/sources/:identifier/events' do
      identifier = params[:identifier]
      events_list = EventName.display_events(identifier)
      erb :events, locals: {events_list: events_list, identifier: identifier}
    end

    not_found do
      erb :error
    end
  end
end
