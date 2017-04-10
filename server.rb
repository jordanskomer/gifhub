def github
  @github ||= GithubApi.new(session[:access_token])
end

def authenticated?
  session[:access_token]
end

def authenticate!
  haml :login, locals: { login_url: GithubApi::auth_url }
end

def repos
  repos = []
  github.repos.each do |repo|
    repo_data = Hash.new
    repo_data[:full_name] = repo.full_name
    repo_data[:name] = repo.name
    repo_data[:owner] = repo.owner
    repo_data[:id] = repo.id
    hooks = github.get_hooks(repo.full_name)
    if hooks
      puts hooks.inspect
      # if hooks.first.config.url == ENV["GITHUB_WEBHOOK_CALLBACK"]
      #   puts "has hook #{repo.name}"
      # end
    end
  end
end

get "/" do
  if !authenticated?
    authenticate!
  else
    haml :index, locals: {data: github.user, repos: github.repos}
  end
end

get "/hook/:user/:repo" do
  github.create_hook("#{params[:user]}/#{params[:repo]}", ENV["GITHUB_WEBHOOK_CALLBACK"])
  redirect "/"
end

get "/comment/:user/:repo/:pr" do

end

get "/callback" do
  session[:access_token] = github.token(request.env["rack.request.query_hash"]["code"])
  redirect "/"
end

CHANG = "![image](https://media.giphy.com/media/V48T5oWs3agg0/giphy.gif)"

post "/payload" do
  puts request.inspect
  payload = JSON.parse(request.body.read)
  # puts payload.inspect
  if payload["pull_request"]
    puts payload["head"].inspect
    puts github.get_commit(payload["head"]["repo"]["full_name"], payload["head"]["sha"]).inspect
  end

  if payload["comment"]
    puts "[#{payload["comment"]["created_at"]}] #{payload["comment"]["user"]["login"]}: #{payload["comment"]["body"]}"

    if payload["comment"]["body"].downcase().include?("chang")
      data = Hash.new
      data[:repo_name] = payload["repository"]["full_name"]
      data[:comment_id] = payload["comment"]["id"]
      if payload["issue"]
        data[:pull_request_number] = payload["issue"]["number"]
        github.create_comment(data[:repo_name], data[:pull_request_number], CHANG)
      else
        data[:pull_request_number] = payload["pull_request"]["number"]
        github.create_pull_request_comment_reply(
            data[:repo_name],
            data[:pull_request_number],
            CHANG,
            payload["comment"]["id"],
          )
      end

      # data = Hash.new
      # data[:comment] = "Hi."
    end
  end

  halt 201
  redirect "/"
end


