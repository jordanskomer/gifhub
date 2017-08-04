require "rubygems"
require "bundler"
require "dotenv/load"
require "sinatra/base"
require "sinatra/activerecord"
# require "./config/environments"
Bundler.require

require File.dirname(__FILE__) + "/app"
# Load Models
Dir.glob(File.dirname(__FILE__) + "/app/models/**/*.rb") { |f| require_relative f }
# Load all lib files
require File.dirname(__FILE__) + "/lib/github.rb"
require File.dirname(__FILE__) + "/lib/github/gifs.rb"
require File.dirname(__FILE__) + "/lib/github/payload.rb"
require File.dirname(__FILE__) + "/lib/github/client.rb"

run Gifhub
