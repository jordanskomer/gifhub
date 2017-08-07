require File.dirname(__FILE__) + "/github/gifs.rb"
require File.dirname(__FILE__) + "/github/payload.rb"
require File.dirname(__FILE__) + "/github/files.rb"
require File.dirname(__FILE__) + "/github/client.rb"

module Github
  CLIENT_ID = ENV["GITHUB_CLIENT_ID"]
  CLIENT_SECRET = ENV["GITHUB_CLIENT_SECRET"]
  WEBHOOK_SECRET = ENV["WEBHOOK_SECRET"]
  APP_ID = ENV["GITHUB_APP_ID"]

  def self.auth_url
    Octokit::Client.new.authorize_url(CLIENT_ID)
  end

  def self.retrieve_access_token(session_code)
    Octokit.exchange_code_for_token(session_code, CLIENT_ID, CLIENT_SECRET).access_token
  end

  def initialize(request)
    @request = request
  end
end
