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
      if file?
        puts "| ---   file"
        files.each do |file|
          comment = Gif.where(github_type: "file").detect { |gif| file[:filename].downcase.include? gif.keyword.downcase }
          create_pull_request_comment(comment.image, file.filename, 1) if comment.present?
        end
      end

      if comment?
        puts "| ---   comment"
        testies = Gif.where(github_type: "comment").detect { |gif| comment.downcase.include? gif.keyword.downcase }
        if testies.present?
          add_comment(testies.image) if issue_comment?
          create_pull_request_comment_reply(testies.image) if pull_request_review_comment?
        end
      end

      if branch?
        puts "| ---   branch"
        comment = Gif.where(github_type: "branch").detect { |gif| head_branch.downcase.include? gif.keyword.downcase }
        unless comment
          comment = Gif.find_by(github_type: "merge") if merged?
          comment = Gif.find_by(github_type: "squerge") if squerged?
        end
        add_comment(comment.image) if comment.present?
      end
    end

    private

    def add_comment(comment)
      puts "|       add_comment #{comment}"
      client.add_comment(repo_full_name, pull_request_number, comment)
    end

    def create_pull_request_comment(comment, file_path, position)
      puts "|       create_pull_request_comment #{comment}"
      client.create_pull_request_comment(
          repo_full_name,
          pull_request_number,
          comment,
          pull_request_sha,
          file_path,
          position
        )
    end

    def create_pull_request_comment_reply(comment)
      puts "|       create_pull_request_comment_reply #{comment}"
      client.create_pull_request_comment_reply(
        repo_full_name,
        pull_request_number,
        comment,
        comment_id,
      )
    end

    def files
      @files ||= client.pull_request_files(repo_full_name, pull_request_number)
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
