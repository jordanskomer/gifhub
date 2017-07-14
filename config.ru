require "rubygems"
require "bundler"
require "dotenv/load"
require "./lib/github_payload"
require "./lib/github_api"

Bundler.require

use Rack::Session::Cookie, :key => "rack.session",
                           :path => "/",
                           :secret => "your_secret_key_path_thing_for_evan"

set :views, Proc.new { File.join(root, "app/assets/views") }

require "./server"
run Sinatra::Application
