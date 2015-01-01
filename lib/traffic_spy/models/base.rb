module TrafficSpy

  if ENV["TRAFFIC_SPY_ENV"] == "test"
    database_file = 'db/traffic_spy-test.sqlite3'
    DB = Sequel.sqlite database_file
  else
    DB = Sequel.postgres "traffic_spy"
  end



end

#
# Require all the files within the model directory here...
#
# @example
#
# require 'traffic_spy/models/request'
require 'traffic_spy/models/event_name'
require 'traffic_spy/models/identifier'
require 'traffic_spy/models/ip'
require 'traffic_spy/models/payload'
require 'traffic_spy/models/referred_by'
require 'traffic_spy/models/request_type'
require 'traffic_spy/models/resolution'
require 'traffic_spy/models/url'
require 'traffic_spy/models/user_agent'
