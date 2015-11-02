# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class Admin < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra
    enable :sessions
    enable :reload
    layout :admin


    ### this runs before all routes ###
    before do
      @title = "Honeybadger CMS"
      @page = !params[:page].blank? ? @page = params[:page].to_i : 1
      @per_page = 15
    end
    ###

    ### routes ###
    get '/' do
      render "index"
    end

    get '/users' do
      @users = User.order(:created_at).reverse.paginate(@page, @per_page)
      render "users"
    end

    get '/user/(:id)' do
      @user = User[params[:id]]
      render "user"
    end

    post '/data/(:cmd)', :provides => :js do

      rules = {
        :model => {:type => 'string', :min => 2, :required => true},
        :cmd => {:type => 'string', :min => 3, :required => true},
      }

      validator = Honeybadger::Validator.new(params, rules)
      if validator.valid?

        # get model obj
        model = Object.const_get(params[:model])

        # check if new or update
        if params[:id].blank?
          model.new
        else
          model = model[params[:id]]
        end

        case params[:cmd]
        when "save"
          model.set(params).save
          "alert('saved!');"
        when "delete"
          abort
          "delete"
        end
      else
        "not valid #{validator.errors}"
      end

    end


  end # end class

end # end module
