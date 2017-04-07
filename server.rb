require 'sinatra'
# require 'rubygems'
require 'Haml'
require 'json'

get '/' do
  haml :index
end

post '/payload' do
  push = JSON.parse(request.body.read)
  puts "I got some JSON: #{push.inspect}"
end