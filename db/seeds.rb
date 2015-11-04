username = 'test@test.com'
password = 'asdfasdf'
user = User.create(:email => username, :username => username, :password => password, :password_confirmation => password, :role => "admin", :provider => "email")
