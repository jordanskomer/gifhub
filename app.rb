require 'sinatra/base'

class Gifhub < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "app/assets/views/") }

  enable :sessions

  # Methods
  # --------
  def github
    @github ||= Github.new(session[:access_token])
  end

  def authenticated?
    session[:access_token]
  end

  def authenticate!
    haml :login, locals: { login_url: Github.auth_url }
  end

  # Lambdas
  # --------
  login = lambda do
    if !authenticated?
      authenticate!
    else
      haml :index, locals: { user: github.user }
    end
  end

  logout = lambda do
    session[:access_token] = nil
    redirect "/"
  end

  admin_login = lambda do
    if !authenticated?
      authenticate!
    else
      haml :admin, locals: {data: github.user, repos: github.repos}
    end
  end

  recieve_callback = lambda do
    session[:access_token] = github.token(request.env["rack.request.query_hash"]["code"])
    redirect "/"
  end

  recieve_payload = lambda do
    request.body.rewind
    payload_body = request.body.read
    payload = Github.verify_webhook_signature(payload_body, request.env["HTTP_X_HUB_SIGNATURE"])
    if payload
      if payload["installation"] && payload["repositories"]
        payload["repositories"].each do |repo|
          puts "hooking into #{repo["full_name"]}"
          puts github.inspect
          github.create_hook(repo["full_name"])
        end
      end
    end

    halt 201
    redirect "/"
  end

  # Routes
  # --------
  get "/", &login
  get "/callback", &recieve_callback
  get "/logout", &logout
  get "/admin", &admin_login
  post "/payload", &recieve_payload

end
