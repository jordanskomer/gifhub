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
      puts "| !!!   #{files.filename.inspect}"
      # gifs.each do |gif|
      #   if pull_request_review_comment?
      #     create_pull_request_comment_reply
      #   elsif issue_comment? || pull_request?
      #     add_comment
      #   end
      # end
    end

    private

    def add_comment
      puts "| !!!   add_comment -#{repo_full_name}, #{pull_request_number}, #{gif.keyword}"
      client.add_comment(repo_full_name, pull_request_number, "![image](#{gif.url})") if gif.present?
    end

    def create_pull_request_comment_reply
      puts "| !!!   create_pull_request_comment_reply - #{repo_full_name}, #{pull_request_number}, #{gif.keyword}, #{comment_id}"
      if gif.present?
        client.create_pull_request_comment_reply(
          repo_full_name,
          pull_request_number,
          "![image](#{gif.url})",
          comment_id,
        )
      end
    end

    def gifs
      # on_merge Activation Gifs
      gifs = []
      if comment?
        gifs.push(comment_gif.comment_instant) if comment?
      elsif pull_request?
        gifs.pushif branch_match?
        gifs.push(gif.merge_on_merge) if merged?
        gifs.push(gif.squerge_on_merge) if squerged?

      end
      gifs
    end

    def branch_match?
      gif.branch_on_merge.each do |gif|
        gif.keyword
      end
    end

    def files
      @files ||= Github::Files.new(client.pull_request_files(repo_full_name, pull_request_number))
    end

    def comment_gif
      @comment_gif ||= Github::Gifs.new(comment)
    end

    def file_gif
      @comment_gif ||= Github::Gifs.new(comment)
    end

    def branch_gif
      @comment_gif ||= Github::Gifs.new(comment)
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
