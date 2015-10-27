require 'rack/test'
require 'rspec'

require_relative '../lib/retro_bot.rb'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.color = true
end

def post_request(token: 'test', user_name: 'test', text: 'test', team_id: '123', channel_id: '456')
  post '/', token: token, user_name: user_name, text: text, team_id: team_id, channel_id: channel_id
end
