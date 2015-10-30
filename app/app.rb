# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class App < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions
    layout :site


    ### run before all routes ###
    before do
      @title = "Honeybadger CMS"
    end


    ### routes ###
    get "/" do
      render "index"
    end

    get "/example" do
      render "example"
    end

    get "/contact" do
      render "contact"
    end

    post "/contact" do
      output(params)
    end

    get "/test" do
      auth = Util::config('auth')
      output("testing #{auth[:twitter_key]}")
    end


    ### authentication routes ###
    use OmniAuth::Builder do
      provider :twitter,  Util::config('auth')[:twitter_key], Util::config('auth')[:twitter_secret]
      provider :instagram,  Util::config('auth')[:instagram_key], Util::config('auth')[:instagram_secret]
    end

    get '/auth/:name/callback' do
      auth    = request.env["omniauth.auth"]
      user = User.login_with_omniauth(auth)

      if user
        session[:user] = user
        redirect("/")
      else
        output(user.values)
        "prob"
      end

    end

    get "/login" do
      render "login"
    end

    get "/logout" do
      session.delete(:user)
      redirect("/")
    end

    get "/signup" do
      render "signup"
    end

    post "/signup" do

      user = User.new
      user.username = params[:email]
      user.email = params[:email]
      user.password = params[:password]
      user.password_confirmation = params[:password]
      user.role = 'users'
      user.provider = 'email'

      if user.valid?
        user.save
        session[:user] = user
        redirect("/")
      else
        output(user.errors)
      end

    end

    # utility
    def output(val)
      case val
      when String
        if Util::valid_json?(val)
          content_type :json
          val.to_json
        else
          val
        end
      when Hash
        content_type :json
        val.to_json
      when Array
        content_type :json
        val.to_s.to_json
      when Fixnum
        val
      else
        val
      end
    end


  end

end
