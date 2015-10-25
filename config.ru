$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'retro_bot'

run Sinatra::Application
