class User < Sequel::Model

  plugin :validation_helpers
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

      user = User.new
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["name"]
      user.username = auth["username"]
      user.email = auth["email"]
      user.role = "users"

      # facebook
      if auth["provider"] == "facebook"
        user.email = auth["user_info"]["email"]
      end

      # twitter
      if auth["provider"] == "twitter"
        user.name = auth["info"]["name"]
        user.username = auth["info"]["username"]
      end

      # instagram
      if auth["provider"] == "instagram"
        user.name = auth["info"]["name"]
        user.username = auth["info"]["username"]
      end

      # create user
      if user.valid?
        user.save
      end

    end

    # return
    return user

  end

end
