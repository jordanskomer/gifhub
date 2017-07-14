class GithubApi
  CLIENT_ID = ENV["GITHUB_CLIENT_ID"]
  CLIENT_SECRET = ENV["GITHUB_CLIENT_SECRET"]
  GIFHUB_USER_TOKEN = ENV["GITHUB_GIFHUB_USER_TOKEN"]

  def self.auth_url
    Octokit::Client.new.authorize_url(CLIENT_ID, scope: ENV["GITHUB_WEBHOOK_SCOPE"])
  end

  def initialize(token)
    @token ||= token
  end

  def client
    @client ||= Octokit::Client.new(access_token: @token, auto_paginate: true)
  end

  def gifhub_client
    @gifhub_client ||= Octokit::Client.new(access_token: GIFHUB_USER_TOKEN, auto_paginate: true)
  end


  def token(session_code)
    Octokit.exchange_code_for_token(session_code, CLIENT_ID, CLIENT_SECRET).access_token
  end

  def user
    data = Hash.new
    data[:username] = client.user.login
    data[:email] = client.user.email
    data[:location] = client.user.location
    data[:avatar] = client.user.avatar_url
    data[:profile_url] = client.user.html_url
    data
  end

  def repos
    client.repos
  end

  def repo(repo_name)
    client.repository(repo_name)
  end

  def get_hooks(full_repo_name)
    hooks = client.hooks(full_repo_name)
    if block_given?
      yield hooks
    else
      "no block_given"
    end
  rescue Octokit::NotFound => error
    false
  end

  def create_hook(full_repo_name, callback_endpoint)
    hook = client.create_hook(
      full_repo_name,
      "web",
      { url: callback_endpoint, content_type: "json"},
      { events: ["commit_comment", "issue_comment", "pull_request_review_comment", "pull_request"], active: true }
    )

    if block_given?
      yield hook
    else
      hook
    end
  rescue Octokit::UnprocessableEntity => error
    if error.message.include? "Hook already exists"
      true
    else
      raise
    end
  end

  def remove_hook(full_github_name, hook_id)
    response = client.remove_hook(full_github_name, hook_id)

    if block_given?
      yield
    else
      response
    end
  end

  def pull_request_comments(repo_full_name, pull_request_number)
    client.pull_request_comments(repo_full_name, pull_request_number)
  end

  def get_comment(repo_full_name, comment_id)
    client.pull_request_comment(repo_full_name, comment_id)
  end

  def create_comment(repo_full_name, pull_request_number, comment)
    gifhub_client.add_comment(repo_full_name, pull_request_number, comment)
  end

  def create_pull_request_comment_reply(repo_full_name, pull_request_id, comment, comment_id)
    gifhub_client.create_pull_request_comment_reply(
      repo_full_name,
      pull_request_id,
      comment,
      comment_id
    )
  end

  def get_commit(repo_full_name, sha)
    client.commit(repo_full_name, sha)
  end

  def get_commit_message(repo_full_name, sha)
    get_commit(repo_full_name, sha)["commit"]["message"]
  end
end
