# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class App < Padrino::Application

    ### stuffs ###
    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions
    layout :site

    ### run before routes ###
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
      content_type :json
      params.to_json
    end

  end

end
