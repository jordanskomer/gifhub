class Gifhub < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "app/assets/views/") }

  enable :sessions

  # Methods
  # --------
  def github
    @github ||= Github::Client.new(session[:access_token])
  end

  def authenticated?
    session[:access_token]
  end

  def authenticate!
    haml :login, locals: { login_url: Github::Base.auth_url }
  end

  # Lambdas
  # --------
  login = lambda do
    if !authenticated?
      authenticate!
    else
      haml :index, locals: { user:  github.user_info }
    end
  end

  logout = lambda do
    session[:access_token] = nil
    redirect "/"
  end

  recieve_callback = lambda do
    session[:access_token] = Github::Base.retrieve_access_token(request.env["rack.request.query_hash"]["code"])
    redirect "/"
  end

  recieve_payload = lambda do
    payload = Github::Payload.new(request)
    puts payload.inspect
    # github.create_comment("jordanskomer/gifhub", "3", "Test")
  end

  # Routes
  # --------
  get "/", &login
  get "/callback", &recieve_callback
  get "/logout", &logout
  post "/payload", &recieve_payload

end
