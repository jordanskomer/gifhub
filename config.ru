require "rubygems"
require "bundler"
require "dotenv/load"
require "sinatra/base"

Bundler.require

require File.dirname(__FILE__) + "/app"

# Load all lib files
Dir.glob(File.dirname(__FILE__) + "/lib/**/*.rb") { |f| require_relative f }

run Gifhub
