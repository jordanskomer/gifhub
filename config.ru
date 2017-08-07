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
# Load Github
require File.dirname(__FILE__) + "/lib/github.rb"

run Gifhub
