require "openssl"
require "jwt"

module Github
  class Client < Github::Base

    def initialize(token)
      puts token
      @token ||= token
    end

    def client
      @client ||= Octokit::Client.new(access_token: @token, auto_paginate: true)
    end

    def bot_client
      @bot_client ||= Octokit::Client.new(access_token: installation_access_token, auto_paginate: true)
    end

    def user_info
      data = Hash.new
      puts client.user.inspect
      data[:username] = client.user.login
      data[:email] = client.user.email
      data[:location] = client.user.location
      data[:avatar] = client.user.avatar_url
      data[:profile_url] = client.user.html_url
      data
    end

    private

    def installation_access_token
      Octokit::Client.new(bearer_token: private_key).create_installation_access_token(installation_id)[:token]
    end

    def installation_id
      @installation_id ||= 39509
    end

    def private_key
      private_pem = File.read("./config/github-private-key.pem")
      private_key = OpenSSL::PKey::RSA.new(private_pem)

      payload = {
        iat: Time.now.to_i,
        exp: Time.now.to_i + (8 * 60),
        iss: APP_ID
      }
      JWT.encode(payload, private_key, "RS256")
    end
  end
end
