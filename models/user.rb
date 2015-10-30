class User < Sequel::Model

  plugin :validation_helpers
  plugin :secure_password
  plugin :timestamps

  def validate
    super
    validates_presence [:username, :role]
  end

  def self.login_with_omniauth(auth)

    # get user
    user = User.where(:provider => auth["provider"], :uid => auth["uid"]).first

    # create if not exist
    if user.nil?
      data = {
        :provider => auth["provider"],
        :uid => auth["uid"],
        :name => auth["name"],
        :username => auth["username"],
        :email => auth["user_info"]["email"],
        :role => "users",
      }

      # facebook
      if auth["provider"] == "facebook"
        data[:email] = auth["user_info"]["email"]
      end

      # twitter
      if auth["provider"] == "twitter"
        data[:name] = auth["info"]["name"]
        data[:username] = auth["info"]["username"]
      end

      # instagram
      if auth["provider"] == "instagram"
        data[:name] = auth["info"]["name"]
        data[:username] = auth["info"]["username"]
      end

      user = User.create(data)

    end

    return user

  end

end
