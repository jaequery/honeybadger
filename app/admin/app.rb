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
    # end user routes



    ### shared routes ###

    # universal model save
    ### /user/save.js
    ### /user/save/22.js
    ### /user/delete/22 .js
    route :post, :get, '/:model/:action/(:id)', :provides => :js  do

      msg = ""

      rules = {
        :model => {:type => 'string', :min => 2, :required => true},
        :action => {:type => 'string', :min => 3, :required => true},
      }
      validator = Honeybadger::Validator.new(params, rules)

      if validator.valid?

        # get model obj
        model = Object.const_get(params[:model].capitalize)

        # run action
        case params[:action]
        when "save"

          # check if new or update
          data = params.except("model", "action", "format")
          if params[:id].blank?
            if model.create(data.except("id"))
              msg = "swal('success', 'created!');"
              msg += "location.href = '/admin/#{params[:model].downcase.pluralize}';"
            else
              msg = "swal('error', 'Sorry, there was a problem creating');"
            end
          else
            model = model[params[:id]]
            model = model.set(data)

            if model.save
              msg = "swal('success', 'updated!');"
            else
              abort
              msg = "swal('error', 'Sorry, there was a problem updating');"
            end
          end

        when "delete"
          model = model[params[:id]]
          if !model.blank? && model.destroy
            msg = "swal('success', 'Record deleted!');"
            msg += "$('#row_#{params[:id]}').slideUp();"
          else
            msg = "swal('error', 'Sorry, there was a problem deleting');"
          end
        end
      else
        msg = "swal('error', 'not valid #{validator.errors}')"
      end

      # output javascript callback msg
      msg

    end

    def only_for(role)
      if session[:user].nil? || (!session[:user][:role].blank? && session[:user][:role] != role)
        redirect("/")
      end
    end

  end # end class

end # end module
