require 'sinatra'
require 'json'
ENV['RACK_ENV'] == 'test' ? require('fakeredis') : require('redis')

require_relative './request_authenticator'
require_relative './request_parser'
require_relative './response_formatter'
require_relative './store_wrapper'

# RetroBot is a simple bot to record retro items.
#
# It responds to a single request and has the following required params:
#
#   token: a secret string used to verify a request.
#   team_id: used in conjunction with the 'channel_id' to form a storage key.
#   channel_id: used in conjunction with the 'team_id' to form a storage key.
#   text: the body of a request.
#   user_name: the user sending the request.
#
# For every request it first validates it is from a trusted source and that it
# is valid, then it parses the provided params to determine what type of request
# it is receiving and responds appropriately.

store = Redis.new(url: ENV['REDISTOGO_URL'])

post '/' do
  return nil unless RequestAuthenticator.authenticate(params.fetch('token'))

  request       = RequestParser.parse(params)
  store_wrapper = StoreWrapper.new(params: params, request: request, store: store)

  return nil unless request.valid?

  response = case request.type
             when :help
               ResponseFormatter.help_text
             when :write
               store_wrapper.add_request
               ResponseFormatter.write_confirmation_text(
                 user:     request.user,
                 category: request.category,
                 item:     request.item
               )
             when :read
               ResponseFormatter.read_items(
                 items:    store_wrapper.get_items,
                 category: request.category
               )
             when :all
               ResponseFormatter.list_all_items(items: store_wrapper.all_items)
             when :delete
               ResponseFormatter.delete_all_items(items: store_wrapper.all_items).tap do
                 store_wrapper.delete_all_items
               end
             end

  { text: response }.to_json
end
