module Github
  class Client
    include Github::Payload

    def initialize(request)
      @request = request
    end

    # create_comment
    # ------------------------------------------
    # Creates the appropriate gif comment based on the payload
    def create_comment
      create_pull_request_comment_reply if pull_request_review_comment?
      add_comment if issue_comment?
    end

    private

    def add_comment
      puts "| !!!   #{repo_full_name}, #{pull_request_number}, #{gif.keyword}"
      client.add_comment(repo_full_name, pull_request_number, "![image](#{gif.url})") if gif.present?
    end

    def create_pull_request_comment_reply
      puts "| !!!   #{repo_full_name}, #{pull_request_number}, #{gif.keyword}, #{comment_id}"
      if gif.present?
        client.create_pull_request_comment_reply(
          repo_full_name,
          pull_request_number,
          "![image](#{gif.url})",
          comment_id,
        )
      end
    end

    def gif
      # on_merge Activation Gifs
      Github::Gifs.new(comment).merge_on_merge if merged?
      Github::Gifs.new(comment).squerge_on_merge if squerged?
      # instant Activation Gifs
      Github::Gifs.new(comment).comment_instant if comment?
    end

    def client
      @client ||= Octokit::Client.new(access_token: installation_access_token, auto_paginate: true)
    end

    def installation_access_token
      Octokit::Client.new(bearer_token: private_key).create_installation_access_token(installation_id)[:token]
    end

    def private_key
      private_pem = File.read("./config/github-private-key.pem")
      private_key = OpenSSL::PKey::RSA.new(private_pem)

      payload = {
        iat: Time.now.to_i,
        exp: Time.now.to_i + (8 * 60),
        iss: APP_ID,
      }
      JWT.encode(payload, private_key, "RS256")
    end
  end
end
