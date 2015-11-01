class User < Sequel::Model

  plugin :timestamps
  plugin :secure_password, include_validations: false

  def validate
    super
    rules = {
      :email => {
        :type => 'email', :min => 4, :required => true
      },
      :role => {
        :type => 'string', :required => true
      },
      :provider => {
        :type => 'string', :required => true
      }
    }
    validator = Honeybadger::Validator.new(self.values, rules)
    errors.add(:validation, validator.errors) if !validator.valid?

  end

  def self.login(params)
    user = User.where(:email => params[:email]).first

    if user.nil?
      user = User.new
      user.errors.add(:validation, 'user not found')
    else
      if user.authenticate(params[:password]).nil?
        user.errors.add(:validation, 'authentication failed')
      end
    end

    return user
  end

  def self.register(params)
    user = User.new
    user.username = params[:email]
    user.email = params[:email]
    user.password = params[:password]
    user.password_confirmation = params[:password]
    user.role = 'users'
    user.provider = 'email'

    if user.valid?
      user.save
    end

    return user
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
