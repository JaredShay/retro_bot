require 'sinatra'
require 'json'

def format_response_text(retro_item, user_name, type)
  "_#{user_name} added a #{type} item_ - #{retro_item}"
end

def authenticated_request?
  params.fetch('token') == ENV['SLACK_TOKEN'].to_s
end

def text_begins_with_keyword_and_type?
  params.fetch('text').match(/\Aretro\s+(positive|negative|question|change)\s+.+/)
end

post '/' do
  return nil unless authenticated_request?
  return nil unless text_begins_with_keyword_and_type?

  text_tokens = params.fetch('text').split
  type        = text_tokens[1]
  retro_item  = text_tokens[2..-1].join(' ')
  user_name   = params.fetch('user_name')

  {
    text: format_response_text(retro_item, user_name, type)
  }.to_json
end
