# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class ApiApp < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra

    # enable :sessions
    require 'rack/session/dalli'
    use Rack::Session::Dalli, {:cache => Dalli::Client.new('memcache:11211')}

    enable :reload
    disable :dump_errors
    layout :site

    ### this runs before all routes ###
    before do
      content_type :json

      if(env['REQUEST_URI'] != '/api/error')
        if params[:token].nil?
          redirect "/api/error"
        end

        @user = User.where(:access_token => params[:token]).first

        if @user.nil?
          redirect "/api/error"
        end
      end
    end

    ### put your routes here ###
    get '/' do
      response = {:user => @user.values, :params => params}
      Util::output(response)
    end

    get '/error' do
      'invalid api token'
    end  

    # api actions
    post '/api/codes/create' do
      "hello"
    end

    # catch all error
    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Not Found']
    end


  end

end
