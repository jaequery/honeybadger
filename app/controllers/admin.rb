Honeybadger::App.controllers :admin do

  layout :admin

  get '/' do
    render "admin/index"
  end

  get '/users' do
    @users = User.all
    render "admin/users"
  end

end
