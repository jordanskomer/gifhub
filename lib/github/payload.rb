module Github
  module Payload
    def payload
      @payload ||= verify_webhook_signature(payload_body, @request.env["HTTP_X_HUB_SIGNATURE"])
    end

    def installing?
      installation? && action == "created"
    end

    def deleting?
      installation? && action == "deleted"
    end

    def installation?
      payload_type == "installation"
    end

    def pull_request?
      payload_type == "pull_request"
    end

    def comment?
      issue_comment? || pull_request_review_comment?
    end

    def merged?
      pull_request_closed? && base_branch == "master"
    end

    def squerged?
      pull_request_closed? && base_branch == "develop"
    end

    def pull_request_closed?
      pull_request? && action == "closed"
    end

    def comment?
      issue_comment? || pull_request_review_comment?
    end

    def issue_comment?
      payload_type == "issue_comment"
    end

    def comment
      payload["comment"]["body"] if issue_comment? || pull_request_review_comment?
    end

    def comment_id
      payload["comment"]["id"] if issue_comment? || pull_request_review_comment?
    end

    def get_comment_position
      payload["comment"]["position"] if pull_request_review_comment?
    end

    def pull_request_review_comment?
      payload_type == "pull_request_review_comment"
    end

    def installation_id
      payload["installation"]["id"]
    end

    def repo_full_name
      if pull_request? || pull_request_review_comment?
        payload["pull_request"]["head"]["repo"]["full_name"]
      elsif issue_comment?
        payload["repository"]["full_name"]
      end
    end

    def pull_request_sha
      payload["pull_request"]["head"]["sha"] if pull_request?
    end

    def pull_request_number
      if pull_request? || pull_request_review_comment?
        payload["pull_request"]["number"]
      elsif issue_comment?
        payload["issue"]["number"]
      end
    end

    def head_branch
      payload["pull_request"]["head"]["ref"]
    end

    def base_branch
      payload["pull_request"]["base"]["ref"]
    end

    def files

    end

    def action
      payload["action"]
    end

    def installation_user
      if installing?
        account = payload["installation"]["account"]
        data = Hash.new
        data[:login] = account["login"]
        data[:github_id] = account["id"]
        data[:avatar] = account["avatar_url"]
        data[:profile_url] = account["html_url"]
        data
      end
    end

    private

    def payload_body
      @payload_body ||= @request.body.read
    end

    def payload_type
      @request.env["HTTP_X_GITHUB_EVENT"] if @request
    end

    def verify_webhook_signature(payload, payload_signature)
      signature = "sha1=" + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha1"), WEBHOOK_SECRET, payload)
      Rack::Utils.secure_compare(signature, payload_signature) ? JSON.parse(payload) : false
    end
  end
end
