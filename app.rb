class Gifhub < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "app/views/") }

  enable :sessions

  # Methods
  # --------
  # def github
  #   @github ||= Github::Client.new(session[:access_token])
  # end

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
      haml :index
    end
  end

  logout = lambda do
    session[:access_token] = nil
    redirect "/"
  end

  setup_user = lambda do
    params[:installation_id]
    redirect "/"
  end

  recieve_callback = lambda do
    session[:access_token] = Github.retrieve_access_token(request.env["rack.request.query_hash"]["code"])
    redirect "/"
  end

  recieve_payload = lambda do
    github = Github::Client.new(request)
    User.create(github.user) if github.installing?
    github.create_comment
    halt 200
  end

  # Routes
  # --------
  get "/", &login
  get "/logout", &logout
  get "/setup", &setup_user
  get "/callback", &recieve_callback
  post "/payload", &recieve_payload
end
