require 'rubygems'
require 'bundler'
require 'dotenv/load'
require "./github_api"

Bundler.require

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret_key_path_thing_for_evan'

require './server'
run Sinatra::Application