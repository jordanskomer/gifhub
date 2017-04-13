class GithubPayload
  def initialize(payload)
    @payload = payload
  end

  def payload_type
    request.env["HTTP_X_GITHUB_EVENT"] if request
  end

  def pull_request?
    payload_type == "pull_request"
  end

  def issue_comment?
    payload_type == "issue_comment"
  end

  def pull_request_review_comment?
    payload_type == "pull_request_review_comment"
  end

  def username
    @payload["comment"]["user"]["login"]
  end

  def created_at
    if pull_request?
      @payload["pull_request"]["created_at"]
    elsif issue_comment?
      @payload["comment"]["created_at"]
    elsif pull_request_review_comment?
      @payload["comment"]["created_at"]
    end
  end

  def comment
    @payload["comment"]["body"] if issue_comment? || pull_request_review_comment?
  end

  def comment_id
    @payload["comment"]["id"] if issue_comment? || pull_request_review_comment?
  end

  def comment_position
    @payload["comment"]["position"] if pull_request_review_comment?
  end

  def repo_full_name
    if pull_request? || pull_request_review_comment
      @payload["pull_request"]["head"]["repo"]["full_name"]
    elsif issue_comment?
      @payload["repository"]["full_name"]
    end
  end

  def pull_request_sha
    @payload["pull_request"]["head"]["sha"] if pull_request?
  end

  def pull_request_number
    if pull_request? || pull_request_review_comment?
      @payload["pull_request"]["number"]
    elsif comment?
      @payload["issue"]["number"]
    end
  end
end