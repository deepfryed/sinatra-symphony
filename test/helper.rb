require 'bundler/setup'
require 'minitest/autorun'
require 'em-synchrony/em-http'
require 'sinatra-symphony'
require 'sinatra/symphony/test'
require 'rack/mapper'

class MiniTest::Spec
  include Rack::Test::Methods
end
