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
      @title = config('site_title') || "Honeybadger CMS"

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
        :name => {:type => 'string', :min => 2, :required => true},
        :email => {:type => 'email', :required => true},
      }
      validator = Honeybadger::Validator.new(data, rules)
      if !validator.valid?
        msg = output_js_validator(validator.errors, 'user')
      else

        # create or update
        if params[:id].blank? # create
          model = User.new(data).save
          if model
            msg = output_js_success('Record has been created!')
            msg += "location.href = '/admin/users';"
          else
            msg = output_js_error('Sorry, there was a problem creating')
          end
        else # update
          model = User[params[:id]]
          if !model.nil?
            model = model.set(data)
            if model.save
              msg = output_js_success('Record has been updated!')
            else
              msg = output_js_error('Sorry, there was a problem updating')
            end
          end
        end # end save

      end # end validator

      msg

    end

    get '/user/delete/(:id)', :provides => :js do
      model = User[params[:id]]
      if !model.nil? && model.destroy
        msg = output_js_success('Record has been deleted!')
        msg += "$('#row_#{params[:id]}').slideUp();"
      else
        msg = output_js_success('Sorry, there was a problem deleting')
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
        msg = output_js_validator(validator.errors)
      else

        if params[:id].blank? # create
          model = Post.new(data).save
          if model
            msg = output_js_success('Record has been created!')
            msg += "location.href = '/admin/posts';"
          else
            msg = output_js_error('Sorry, there was a problem creating')
          end
        else # update
          model = Post[params[:id]]
          if !model.nil?
            model = model.set(data)
            if model.save
              msg = output_js_success('Record has been updated!')
            else
              msg = output_js_error('Sorry, there was a problem updating')
            end
          end
        end # end save

      end  # end validator

      msg

    end

    get '/post/delete/(:id)', :provides => :js do
      model = Post[params[:id]]
      if !model.nil? && model.destroy
        msg = output_js_success('Record deleted!')
        msg += "$('#row_#{params[:id]}').slideUp();"
      else
        msg = output_js_error('Sorry, there was a problem deleting')
      end
    end
    # end post routes


    # config routes
    get '/configs' do
      @configs = Config.order(:id).reverse
      render "configs"
    end

    get '/config/(:id)' do
      @config = Config[params[:id]]
      render "config"
    end

    post '/config/save/(:id)', :provides => :js do
      data = params[:config]

      # validate fields
      rules = {
        :name => {:type => 'string', :required => true},
      }
      validator = Honeybadger::Validator.new(data, rules)
      if !validator.valid?
        msg = output_js_validator(validator.errors)
      else

        # create or update
        if params[:id].blank? # create
          model = Config.new(data).save
          if model
            msg = output_js_success('Record has been created!')
            msg += "location.href = '/admin/configs';"
          else
            msg = output_js_error('Sorry, there was a problem creating')
          end
        else # update
          model = Config[params[:id]]
          if !model.nil?
            model = model.set(data)
            if model.save
              msg = output_js_success('Record has been updated!')
            else
              msg = output_js_error('Sorry, there was a problem updating')
            end
          end
        end # end save

      end # end validator

      msg

    end

    get '/config/delete/(:id)', :provides => :js do
      model = Config[params[:id]]
      if !model.nil? && model.destroy
        msg = output_js_success('Record deleted!')
        msg += "$('#row_#{params[:id]}').slideUp();"
      else
        msg = output_js_error('Sorry, there was a problem deleting')
      end
    end
    # end config routes


    ### end of routes ###



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

    def output_js_success(msg)
      js = "$('.form-group').attr('class','form-group');"
      js += "swal('Success!', '#{msg}', 'success');"
    end

    def output_js_error(msg)
      js = "$('.form-group').attr('class','form-group');"
      js += "swal('Ooops, there was a problem ...', '#{msg}', 'error');"
    end

    def output_js_validator(errors, form_model='')
      js = "$('.form-group').attr('class','form-group');"

      # sweet alert
      js += "swal('Validation error!', '"
      errors.each do |error|
        js += "#{error[:name]} #{error[:error]}\\n"
      end
      js += "', 'error');\n"

      # form errors
      if !form_model.blank?
        errors.each do |error|
          js += "$('##{form_model}_#{error[:name]}').closest('.form-group').attr('class', 'form-group').addClass('has-error');\n"
        end
      end

      # return msg
      js
    end

  end # end class

end # end module
