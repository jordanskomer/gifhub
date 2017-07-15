module Github
  class Base
    CLIENT_ID = ENV["GITHUB_CLIENT_ID"]
    CLIENT_SECRET = ENV["GITHUB_CLIENT_SECRET"]
    WEBHOOK_SECRET = ENV["WEBHOOK_SECRET"]
    APP_ID = ENV["GITHUB_APP_ID"]

    def self.auth_url
      Octokit::Client.new.authorize_url(CLIENT_ID)
    end

    def self.verify_webhook_signature(payload, payload_signature)
      signature = "sha1=" + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), WEBHOOK_SECRET, payload)
      Rack::Utils.secure_compare(signature, payload_signature) ? JSON.parse(payload) : false
    end

    def self.retrieve_access_token(session_code)
      Octokit.exchange_code_for_token(session_code, CLIENT_ID, CLIENT_SECRET).access_token
    end
  end
end
