# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class SiteApp < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra
    enable :sessions
    enable :reload
    layout :site


    ### this runs before all routes ###
    before do
      @title = "Honeybadger CMS"
    end

    ### authentication routes ###
    auth_keys = settings.auth # @todo: settings is not available in Builder

    use OmniAuth::Builder do

      # /auth/twitter
      provider :twitter,  auth_keys[:twitter][:key], auth_keys[:twitter][:secret]

      # /auth/instagram
      provider :instagram,  auth_keys[:instagram][:key], auth_keys[:instagram][:secret]

    end

    get '/auth/:name/callback' do
      auth    = request.env["omniauth.auth"]
      user = User.login_with_omniauth(auth)

      if user
        session[:user] = user

        if user.email.nil?
          redirect("/user/account", :notice => 'Please fill in required informations')
        end

        redirect("/")
      else
        output(user.values)
      end
    end

    get "/user/account" do
      render "account"
    end

    post "/user/account" do
      session["user"].set(params)
      session["user"].save
      redirect("/user/account")
    end

    get "/user/login" do
      render "login"
    end

    post "/user/login" do
      user = User.login(params)
      if user.errors.empty?
        session[:user] = user
        flash[:notice] = "You are now logged in"
        redirect("/")
      else
        flash[:notice] = user.errors[:validation]
        redirect("/user/login")
      end

    end

    get "/user/logout" do
      session.delete(:user)
      redirect("/")
    end

    get "/user/register" do
      render "register"
    end

    post "/user/register" do

      user = User.register_with_email(params)
      if user.errors.empty?
        session[:user] = user
        redirect("/")
      else
        flash[:notice] = "Please try again"
        redirect("/user/register")
      end

    end


    ### put your routes here ###
    get :index do
      @title = "Honeybadger CMS"
      @posts = Post.all.reverse
      render "posts"
    end

    get '/debug' do
      abort
    end

    ### view page ###
    get :index, :with => [:title, :id] do
      @post = Post[params[:id]]
      render "post"
    end

    get :about do
      render "about"
    end






    





  end

end
