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
      provider :twitter,  'kNDElilnZeGQwhYwci0zrn2V9', '4m00r0eCAEy4MbOQUwb0S1milhavlxMKDrDmE7Bm4g5pkRmkZg'
      provider :instagram,  '66ccf67d4f094f849063bf94f8959350', 'fd30c164216a4ab8ad17e6ed19ed4122'
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

  <<-HTML
#{settings.omg}
  <a href='/auth/twitter'>Sign in with Twitter</a><br>
  <a href='/auth/instagram'>Sign in with Instagram</a><br>
  <a href='/auth/facebook'>Sign in with Facebook</a><br>
  <a href='/auth/github'>Sign in with Github</a><br>
  <a href='/auth/linkedin'>Sign in with Linkedin</a><br>
  HTML
    end

  end

end
