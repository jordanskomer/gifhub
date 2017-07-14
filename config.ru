require "rubygems"
require "bundler"
require "dotenv/load"

Bundler.require

use Rack::Session::Cookie, :key => "rack.session",
                           :path => "/",
                           :secret => "your_secret_key_path_thing_for_evan"

set :views, Proc.new { File.join(root, "app/assets/views") }

# Load all lib files
configure do
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib|
    require File.basename(lib, '.*')
  }
end

require "./server"
run Sinatra::Application
