Honeybadger::App.controllers :admin do

  layout :admin

  before do
    @page = !params[:page].blank? ? @page = params[:page].to_i : 1
    @per_page = 15
  end

  get '/users' do
    @users = User.order(:created_at).reverse.paginate(@page, @per_page)
    render "admin/users"
  end

  get '/user/(:id)' do
    @user = User[params[:id]]
    render "admin/user"
  end

end
