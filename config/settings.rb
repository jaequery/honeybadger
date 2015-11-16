### app specific settings, you can access them like this: settings.auth[:twitter][:key] ###
#Padrino.configure_apps do

# single sign on credentials
$stuff = 'hola'
set :auth, {
      :twitter => {:key => '', :secret => ''},
      :instagram => {:key => 'key', :secret => 'secret'}
    }

set :defaults, {
      :avatar_url => "http://images.mentalfloss.com/sites/default/files/styles/insert_main_wide_image/public/600honeybadger_plush.jpg"
    }

#end
