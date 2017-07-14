require "rubygems"
require "bundler"
require "dotenv/load"

Bundler.require

require File.dirname(__FILE__) + '/app'

# Load all lib files
configure do
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib|
    require File.basename(lib, '.*')
  }
end

run Gifhub
