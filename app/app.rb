# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class App < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    enable :sessions
    layout :site

    ### run before routes ###
    before do
      @title = "Honeybadger CMS"
    end

    ### single sign on ###
    use OmniAuth::Builder do
      provider :twitter,  '--key--', '--secret--'
      provider :instagram,  '--key--', '--secret--'
    end

    get '/auth/:name/callback' do
      auth    = request.env["omniauth.auth"]
      Account.login_with_omniauth(auth)
      content_type :json
      auth.to_json
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

    get "/login" do
      render "login"
    end

  end

end
