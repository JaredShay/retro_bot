require 'sinatra'
require 'json'
require 'redis'

require_relative './request_authenticator'
require_relative './request_parser'
require_relative './response_formatter'
require_relative './store_wrapper'

store = Redis.new

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
             when :delete
               ResponseFormatter.all_items(items: store_wrapper.all_items).tap do
                 store_wrapper.delete_all_items
               end
             end

  { text: response }.to_json
end
