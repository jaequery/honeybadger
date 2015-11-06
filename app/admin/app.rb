# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class Admin < Padrino::Application

    register Sinatra::MultiRoute
    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra

    enable :sessions
    enable :reload
    layout :admin

    ### this runs before all routes ###
    before do

      only_for("admin")
      @title = "Honeybadger CMS"

    end
    ###

    ### routes ###
    get '/' do
      render "index"
    end

    # user routes
    get '/users' do
      @users = User.order(:id).reverse
      render "users"
    end

    get '/user/(:id)' do
      @user = User[params[:id]]
      render "user"
    end

    post '/user/save/(:id)', :provides => :js do
      data = params[:user]

      # validate fields
      rules = {
        :email => {:type => 'email', :required => true},
      }
      validator = Honeybadger::Validator.new(data, rules)
      if !validator.valid?
        msg = output_validator(validator)
      else

        # create or update
        if params[:id].blank? # create
          model = User.new(data).save
          if model
            msg = "swal('Sucess!', 'Record has been created!', 'success');"
            msg += "location.href = '/admin/users';"
          else
            abort
            msg = "swal('Oops ...', 'Sorry, there was a problem creating', 'error');"
          end
        else # update
          model = User[params[:id]]
          if !model.nil?
            model = model.set(data)
            if model.save
              msg = "swal('Success!', 'Record has been updated!', 'success');"
            else
              abort
              msg = "swal('Oops ...', 'Sorry, there was a problem updating', 'error');"
            end
          end
        end # end save

      end # end validator

      msg

    end

    post '/user/delete/(:id)', :provides => :js do
      model = User[params[:id]]
      if !model.nil? && model.destroy
        msg = "swal('Success!', 'Record deleted!', 'success');"
        msg += "$('#row_#{params[:id]}').slideUp();"
      else
        msg = "swal('Oops ...', 'Sorry, there was a problem deleting', 'error');"
      end
    end
    # end user routes

    # post routes
    get '/posts' do
      @posts = Post.order(:id).reverse
      render "posts"
    end

    get '/post/(:id)' do
      @post = Post[params[:id]]
      render "post"
    end

    post '/post/save/(:id)', :provides => :js do
      data = params[:post]

      # validate fields
      rules = {
        :user_id => {:type => 'numeric', :required => true},
        :title => {:type => 'string', :min => 2, :max => 128, :required => true},
        :content => {:type => 'string', :required => true},
      }
      validator = Honeybadger::Validator.new(data, rules)
      if !validator.valid?
        msg = output_validator(validator)
      else

        if params[:id].blank? # create
          model = Post.new(data).save
          if model
            msg = "swal('Success!', 'Record has been created!', 'success');"
            msg += "location.href = '/admin/posts';"
          else
            msg = "swal('Oops ...', 'Sorry, there was a problem creating', 'error');"
          end
        else # update
          model = Post[params[:id]]
          if !model.nil?
            model = model.set(data)
            if model.save
              msg = "swal('Success!', 'Record has been updated!', 'success');"
            else
              abort
              msg = "swal('Ooops ...', 'Sorry, there was a problem updating', 'error');"
            end
          end
        end # end save

      end  # end validator

      msg

    end

    get '/post/delete/(:id)', :provides => :js do
      model = Post[params[:id]]
      if !model.nil? && model.destroy
        msg = "swal('success', 'Record deleted!');"
        msg += "$('#row_#{params[:id]}').slideUp();"
      else
        msg = "swal('Oops ...', 'Sorry, there was a problem deleting', 'error');"
      end
    end
    # end post routes


    # controller helper methods
    def only_for(role)
      if session[:user].nil? || (!session[:user][:role].blank? && session[:user][:role] != role)
        redirect("/")
      end
    end

    ### utility methods ###
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
        val.to_json
      when Fixnum
        val
      else
        val
      end
    end

    def output_validator(validator)
      msg = "swal('Validation error!', '"
      validator.errors.each do |error|
        msg += "#{error[:name]} #{error[:error]}\\n"
      end
      msg += "', 'error');"
      msg
    end

  end # end class

end # end module
