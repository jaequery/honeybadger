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

    get '/test' do
      render "test"
    end

    post '/test', :provides => :js do
      "alert('User is not valid');"
    end


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


    ### authentication routes ###
    auth_keys = settings.auth # @todo: settings is not available in Builder
    use OmniAuth::Builder do
      provider :twitter,  auth_keys[:twitter][:key], auth_keys[:twitter][:secret]
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

    post "/login" do

      user = User.login(params)

      if user.errors.blank?
        session[:user] = user
        redirect("/")
      else
        flash[:notice] = user.errors[:validation][0]
        redirect("/login")
      end

    end

    get "/logout" do
      session.delete(:user)
      redirect("/")
    end

    get "/signup" do
      render "signup"
    end

    post "/signup" do

      user = User.register(params)
      if user.errors.blank?
        session[:user] = user
        redirect("/")
      else
        #flash[:notice] = user.errors[:validation][0]
        output(user.errors)
      end

    end

    # utility
    def output(val)
      case val
      when String
        if val.is_json?(val)
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
