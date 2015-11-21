# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class Blog < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra
    enable :sessions
    enable :reload
    layout :blog


    ### this runs before all routes ###
    before do
      @title = "Honeybadger CMS"
    end


    ### put your routes here ###
    get :index do
      @posts = Post.all.reverse
      render "index"
    end

    get :index, :with => [:title, :id] do
      @post = Post[params[:id]]
      render "view"
    end

  end

end
