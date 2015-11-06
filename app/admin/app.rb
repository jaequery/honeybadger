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

    post '/user/save/(:id)' do
      data = params[:user]
      if params[:id].blank? # create
        model = User.new(data).save
        if model
          msg = "swal('success', 'created!');"
          msg += "location.href = '/admin/users';"
        else
          abort
          msg = "swal('error', 'Sorry, there was a problem creating');"
        end
      else # update
        model = User[params[:id]]
        if !model.nil?
          model = model.set(data)
          if model.save
            msg = "swal('success', 'updated!');"
          else
            abort
            msg = "swal('error', 'Sorry, there was a problem updating');"
          end
        end
      end
    end

    get '/user/delete(:id)' do
      model = User[params[:id]]
      if !model.nil? && model.destroy
        msg = "swal('success', 'Record deleted!');"
        msg += "$('#row_#{params[:id]}').slideUp();"
      else
        msg = "swal('error', 'Sorry, there was a problem deleting');"
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

    post '/post/save/(:id)' do
      data = params[:post]
      if params[:id].blank? # create
        model = Post.new(data).save
        if model
          msg = "swal('success', 'created!');"
          msg += "location.href = '/admin/posts';"
        else
          abort
          msg = "swal('error', 'Sorry, there was a problem creating');"
        end
      else # update
        model = Post[params[:id]]
        if !model.nil?
          model = model.set(data)
          if model.save
            msg = "swal('success', 'updated!');"
          else
            abort
            msg = "swal('error', 'Sorry, there was a problem updating');"
          end
        end
      end
    end

    get '/post/delete(:id)' do
      model = Post[params[:id]]
      if !model.nil? && model.destroy
        msg = "swal('success', 'Record deleted!');"
        msg += "$('#row_#{params[:id]}').slideUp();"
      else
        msg = "swal('error', 'Sorry, there was a problem deleting');"
      end
    end
    # end post routes


    # controller helper methods
    def only_for(role)
      if session[:user].nil? || (!session[:user][:role].blank? && session[:user][:role] != role)
        redirect("/")
      end
    end

  end # end class

end # end module
