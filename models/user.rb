require 'digest'

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

    return user
  end

  def before_save
    if self[:access_token] == ''
      self[:access_token] = SecureRandom.urlsafe_base64(nil, false) #Digest::SHA256.base64digest self[:id].to_s + Time.now.to_i.to_s
    end

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

    if !self[:w9_url].blank? && self[:w9_url].class == Hash
      tempfile = self[:w9_url][:tempfile]
      path = "/uploads/w9/" + SecureRandom.hex + '_' + self[:w9_url][:filename].to_slug
      local_dest = Dir.pwd + "/public/" + path
      FileUtils.mv(tempfile.path, local_dest)      
      self[:w9_url] = path
      self[:w9_status] = 'pending'
    end

    super
  end

  def self.register_with_email(params, role = "users")

    user = User.where(:email => params[:email]).first

    if user.nil? 
    
      user = User.new.set(params)
      user.role = role
      user.provider = 'email'
      user.username = params[:email]
      
      if user.valid?      

        user.save

        if !params[:invite_id].nil?
          Invite.where(:id => params[:invite_id]).update(:status => 'accepted', :email => user.email)
        end

      end

    else

      if user.authenticate(params[:password]).nil?
        user.errors.add(:validation, 'Sorry, email is already registered in system')
      end

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
