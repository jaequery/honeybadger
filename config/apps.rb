Padrino.configure_apps do
    enable :sessions
    set :session_secret, '52cb066050f4e1bef0802bef111939d64969136a6774f7d34f26f682cf4e10e9'
    set :protection, :except => :path_traversal
    #set :protect_from_csrf, true
    # set :protect_from_csrf, except: %r{/__better_errors/\w+/\w+\z} if Padrino.env == :development
    
    ### app specific settings, you can access them like this: settings.auth[:twitter][:key] ###
    # single sign on credentials
    set :auth, {
        :twitter => {:key => '', :secret => ''},
        :instagram => {:key => '', :secret => ''}
    }

    set :delivery_method, :smtp => {
      :address              => "email-smtp.us-east-1.amazonaws.com",
      :port                 => 587,
      :user_name            => '',
      :password             => '',
      :authentication       => 'plain',      
      :enable_starttls_auto => true,    
    }

    set :bcc, ['john@doe.com']
    set :mailjet, {
      :api_key => "",
      :secret_key => "",
      :from => 'john@doe.com',
      :template_id => 0,
    }

end

# Mounts the core application for this project
Padrino.mount('Honeybadger::ApiApp', :app_file => Padrino.root('app/api/app.rb')).to('/api')
Padrino.mount('Honeybadger::DashboardApp', :app_file => Padrino.root('app/dashboard/app.rb')).to('/dashboard')
Padrino.mount('Honeybadger::SiteApp', :app_file => Padrino.root('app/site/app.rb')).to('/')
