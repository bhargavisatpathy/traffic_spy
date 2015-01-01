ENV["RACK_ENV"] = "test"
ENV["TRAFFIC_SPY_ENV"] ||= "test"
$:.unshift File.expand_path("../../lib", __FILE__)
require 'traffic_spy'

require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'
require 'nokogiri'
