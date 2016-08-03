# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class SiteApp < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra    
    use Rack::Session::Dalli, {:cache => Dalli::Client.new('memcache:11211')}    
    enable :reload
    disable :dump_errors
    layout :site

    ### this runs before all routes ###
    before do      

      # Login Bug
      if !session[:user_id].nil?
        session[:user] = User[session[:user_id]]
      end

      @title = setting('site_title') || "Company"
      @page = (params[:page] || 1).to_i
      @per_page = params[:per_page] || 25              

      if env["REQUEST_URI"].include? "logout"
        session.destroy
        redirect "/"
      end

    end

    ### put your routes here ###
    get '/' do
      render "index"
    end

    get '/about' do
      render "about"
    end

    ### authentication routes ###
    #abort
    # auth_keys = setting('auth')

    # use OmniAuth::Builder do

    #   # /auth/twitter
    #   provider :twitter,  auth_keys[:twitter][:key], auth_keys[:twitter][:secret]

    #   # /auth/instagram
    #   provider :instagram,  auth_keys[:instagram][:key], auth_keys[:instagram][:secret]

    # end

    get '/auth/:name/callback' do
      auth = request.env["omniauth.auth"]
      user = User.login_with_omniauth(auth)

      if user
        session[:user] = user

        if user.email.blank?
          redirect("/user/account", :notice => 'Please fill in required informations')
        end

        redirect("/")
      else
        output(user.values)
      end
    end

    get "/user/account" do
      @user = session[:user]

      render "account"
    end

    post "/user/account" do

      rules = {
          #:email => {:type => 'email', :required => true},
          :first_name => {:type => 'string', :required => true},
          :last_name => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)

      @user = session[:user]
      @user.email = params[:email]
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]

      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "account"
      else
        @user.save_changes
        redirect("/user/account", :success => 'Account information updated!')
      end

    end

    get "/user/login" do
      render "login"
    end

    post "/user/login" do

      rules = {
          #:email => {:type => 'email', :required => true},
          :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "login"
      else
        user = User.login(params)
        if user.errors.empty?
          session[:user_id] = user[:id]
          flash[:success] = "You are now logged in"
          redirect("/dashboard")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "login"
        end
      end

    end

    get "/user/logout" do
      session.destroy
      redirect("/")
    end

    get "/user/register" do
      render "register"
    end

    post "/user/register" do

      rules = {
          :first_name => {:type => 'string', :required => true},
          :last_name => {:type => 'string', :required => true},
          :email => {:type => 'email', :required => true},
          :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "register"
      else

        user = User.register_with_email(params)
        if user.errors.empty?
          session[:user] = user
          redirect("/user/account")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "register"
        end

      end

    end

    get "/user/forgot_pass" do
      render "forgot_pass"
    end

    post "/user/forgot_pass" do

      rules = {
          :email => {:type => 'email', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        redirect("/user/forgot_pass", :notice => validator.errors[0][:error])
      else

        user = User.where(:email => params[:email]).first

        if !user.nil?

          # create message
          hash = Util::encrypt(params[:email])
          mailjet({
            :to => params[:email],            
            :subject => 'Forgot email from company.com', 
            :template => {
              :id => 37070,
              :link => "https://www.company.com/user/reset_pass/#{hash}",
            },
          })

          redirect("/user/forgot_pass", :success => "Password reset instructions sent to your email")
        else
          redirect("/user/forgot_pass", :notice => "Could not locate that email, please try again")
        end

      end

    end


    get "/user/reset_pass/:hash" do
      render "reset_pass"
    end

    post "/user/reset_pass" do

      rules = {
          :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        redirect("/user/reset_pass", :notice => validator.errors[0][:error])
      else

        email = Util::decrypt(params[:hash])
        user = User.where(:email => email).first

        if !user.nil?

          user.password = params[:password]
          user.password_confirmation = params[:password]
          if user.save
            # create message
            redirect("/user/login", :success => "Password has reset, please login with your new password")
          end
        else
          redirect("/user/reset_pass/#{params[:hash]}", :notice => "There was a problem resetting your password, please try again")
        end

      end

    end

    get "/invitation/:hash" do
      invite_id = Util::decrypt(params[:hash])
      invite = Invite[invite_id]
      session[:invite_id] = invite[:id]
      session[:referral_user_id] = invite[:user_id]
      redirect "/register"
      #render "invitation"
    end

    get :posts do
      @title = "Honeybadger CMS"
      @posts = Post.order(:id).paginate(@page, @per_page).reverse
      render "posts"
    end

    ### view page ###
    get :post, :with => [:title, :id] do
      @post = Post[params[:id]]
      render "post"
    end

    get :about do
      render "about"
    end

    # catch all error 
    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Not Found']
    end


  end

end
