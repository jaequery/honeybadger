class Account < Sequel::Model

  def self.login_with_omniauth(auth)

    # get account
    account = Account.where(:provider => auth["provider"], :uid => auth["uid"]).first

    # create if not exist
    if account.nil?
      data = {
        :provider => auth["provider"],
        :uid => auth["uid"],
        :name => auth["name"],
        :nickname => auth["nickname"],
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
        data[:nickname] = auth["info"]["nickname"]
      end

      # instagram
      if auth["provider"] == "instagram"
        data[:name] = auth["info"]["name"]
        data[:nickname] = auth["info"]["nickname"]
      end

      account = Account.create(data)

    end

    return account

  end

end
