Padrino.configure_apps do
enable :sessions
set :session_secret, '52cb066050f4e1bef0802bef111939d64969136a6774f7d34f26f682cf4e10e9'
set :protection, :except => :path_traversal
#set :protect_from_csrf, true
#set :protect_from_csrf, except: %r{/__better_errors/\w+/\w+\z} if Padrino.env == :development
### app specific settings, you can access them like this: settings.auth[:twitter][:key] ###
# single sign on credentials
set :auth, {
:twitter => {:key => '', :secret => ''},
:instagram => {:key => '', :secret => ''}
}
end

#ip = request.ip
#Hit.create(:ip => 7, :created_at => Time.now)

# Mounts the core application for this project
Padrino.mount('Honeybadger::AdminApp', :app_file => Padrino.root('app/admin/app.rb')).to('/admin')
Padrino.mount('Honeybadger::SiteApp', :app_file => Padrino.root('app/site/app.rb')).to('/')