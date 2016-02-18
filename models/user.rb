class User < Sequel::Model

  plugin :timestamps
  plugin :secure_password, include_validations: false

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

    if user
#      session[:user] = user
    end

    return user
  end

  def before_save

    if self[:provider] == "email" && !self[:email].nil? && self[:refid].nil?
      self[:refid] = self[:email]
    end

    if !self[:avatar_url].blank? && self[:avatar_url].class == Hash
      tempfile = self[:avatar_url][:tempfile]
      path = "/uploads/" + self[:avatar_url][:filename]
      local_dest = Dir.pwd + "/public/" + path
      FileUtils.mv(tempfile.path, local_dest)
      self[:avatar_url] = path
    end

    super
  end

  def self.register_with_email(params, role = "users")
    user = User.new
    user.first_name = params[:first_name]
    user.last_name = params[:last_name]
    user.address = params[:address]
    user.address2 = params[:address2]
    user.city = params[:city]
    user.state = params[:state]
    user.zip = params[:zip]
    user.country = params[:country]
    user.email = params[:email]
    user.username = params[:email]
    user.refid = params[:email]
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    user.role = role
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
      user.first_name = auth["name"].split(" ").first if !auth["name"].nil?
      user.last_name = auth["name"].split(" ").last if !auth["name"].nil?
      user.username = auth["username"]
      user.email = auth["email"]
      user.role = "users"

      # facebook
      if auth["provider"] == "facebook"
        user.email = auth["user_info"]["email"]
      end

      # twitter
      if auth["provider"] == "twitter"
        user.first_name = auth["info"]["name"].split(" ").first
        user.last_name = auth["info"]["name"].split(" ").last
        user.username = auth["info"]["username"]
      end

      # instagram
      if auth["provider"] == "instagram"
        user.first_name = auth["info"]["name"].split(" ").first
        user.last_name = auth["info"]["name"].split(" ").last
        user.username = auth["info"]["nickname"]
        user.refid = auth["uid"]
        user.avatar_url = auth["info"]["image"]
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
