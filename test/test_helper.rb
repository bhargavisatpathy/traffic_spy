ENV["TRAFFIC_SPY_ENV"] ||= "test"
$:.unshift File.expand_path("../../lib", __FILE__)
require 'traffic_spy'

require 'minitest/autorun'
require 'rack/test'
require 'nokogiri'
