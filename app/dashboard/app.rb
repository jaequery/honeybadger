# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class DashboardApp < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra
    use Rack::Session::Dalli, {:cache => Dalli::Client.new('memcache:11211')}
    enable :reload
    disable :dump_errors
    layout :dashboard

    ### this runs before all routes ###
    before do

      # Login Bug
      if !session[:user_id].nil?
        session[:user] = User[session[:user_id]]
      end

      @title = setting('site_title') || "Bambee"
      @page = (params[:page] || 1).to_i
      @per_page = params[:per_page] || 25
      if session[:user].nil?
        redirect "/user/login"
      end

      case session[:user][:role] when "pending_marketer", "pending_company" then
        redirect "/beta/pending"
      end

    end

    ### routes ###
    get '/' do
      redirect "/dashboard/users"
      #render "index"
    end

    get '/team' do
      @slots_open = session[:user][:open_slots] || setting('open_slots').to_i
      @slots = Array.new(@slots_open)
      @invites = Invite.where(:user_id => session[:user][:id]).all

      @invites.each_with_index do |invite, i|
        @slots[i] = invite
        @slots_open = @slots_open - 1
      end
      render "team"
    end

    post '/invite' do    

      to = nil    

      if params[:cmd] == 'cancel'
        response = Invite.where(:user_id => session[:user][:id], :email => params[:email]).delete
        res = {:status => 'ok', :msg => 'deleted', :response => response.to_s}
      elsif params[:cmd] == 'resend'
        invite = Invite.where(:user_id => session[:user_id], :email => params[:email]).first
        invite[:updated_at] = Time.now
        hash = invite[:hash]
        to = params[:email]

        # need msg
        email({
          :from => from, 
          :to => to, 
          :subject => subject, 
          :body=> msg,
          :bcc => setting('bcc')
        })
        
        invite.save_changes
        res = {:status => 'ok', :msg => 'email resent', :env => Padrino.env}
      else
        data = {
          :user_id => session[:user][:id],
          :email => params[:email],
          :status => 'pending',
          :created_at => Time.now
        }

        record = Invite.where(:email => params[:email]).first
        user = User.where(:email => params[:email]).first

        if record.nil? && user.nil?
          invite = Invite.new(data).save
          hash = Util::encrypt(invite[:id])
          to = params[:email]          
          invite[:hash] = hash
          invite.save_changes
          res = {:status => 'ok', :msg => 'Invite sent', :env => Padrino.env}
        else
          res = {:status => 'error', :msg => 'Sorry, that email already exists in the system. Please contact support@markett.com if you require further assistance.'}
        end
      end
      
      # send invite email
      if !to.nil?

        # mailjet({
        #   :to => to,
        #   :subject => "You've been invited by #{session[:user][:first_name]} #{session[:user][:last_name]}",
        #   :template => {
        #     :id => 36733,
        #     :name => "#{session[:user][:first_name]} #{session[:user][:last_name]}",
        #     :link => "#{@site_url}/invitation/#{hash}",
        #   }
        # })

        from = "support@markett.com"
        subject = "You've been invited by #{session[:user][:first_name]} #{session[:user][:last_name]}"
        body = "Hello Future Marketer!

You have been invited by a friend #{session[:user][:first_name]} #{session[:user][:last_name]} to join Markett during our exclusive early-access beta test. Please follow the link below to create your Markett account and get started right away!  Market Technologies is a revolutionary platform designed to make it easier for great people to promote great companies. 

CREATE YOUR ACCOUNT HERE #{@site_url}/invitation/#{hash}

Best,

The Markett Team
"
        email({
          :from => from, 
          :to => to, 
          :subject => subject, 
          :body=> body,
          :bcc => setting('bcc')
        })
        
      end
      
      output(res)
    end

    get '/promote' do
      @companies = Company.where(:companies__status => ['active', 'soon']).order(:rank).paginate(@page, 12)
      #@companies = Company.left_join(:codes, :company_id => :id).where(:codes__id => nil)

      # abort
      render "promote"
    end

    post '/promote/:company_id' do

      codes = Code.where(:company_id => params[:company_id], :user_id => nil).all

      # if codes are not available
      if codes.blank?
        
        res = {:msg => "Sorry, no more codes left", :code => 404}

      # if codes are available
      else

        # get the company's code owned by user
        code = Code.where(:company_id => params[:company_id], :user_id => session[:user][:id]).first

        # if it doesn't exist, create new
        promo = {
          :code => code.nil? ? nil : code.values,
          :company => Company[params[:company_id]].values,
        }

        if code.nil?
          code = Code.where(:company_id => params[:company_id], :user_id => nil).first
          code.user_id = session[:user][:id]
          code.save_changes

          promo[:code] = code.values
          res = {:msg => "Promo code unlocked", :code => 200, :promo => promo}
        else
          res = {:msg => "Promo code already unlocked", :code => 200, :promo => promo}  
        end
        
      end

      output(res)

    end

    get '/promoted/(:company_id)' do
      query = Code.left_join(:companies, :id => :company_id).where(:codes__user_id => session[:user][:id]).order(:codes__id)
      if !params[:company_id].nil?
        query = query.and(:company_id => params[:company_id])
      end
      @companies = query.paginate(@page, 12).reverse

      render "promoted"
    end

    get '/earnings' do
      #@balance = Transaction.where(:user_id => session[:user][:id], :withdrawal_id => nil).sum(:amount)
      @balance = Transaction.where(:user_id => session[:user][:id]).sum(:amount)
      @transactions = Transaction.where(:user_id => session[:user][:id]).order(:id).paginate(@page, 10).reverse
      render "earnings"
    end

    get '/withdraw' do

      @user = session[:user]
      @type = "paypal"
      @reference = @user[:paypal_email]
      @balance = Transaction.where(:user_id => session[:user][:id], :withdrawal_id => nil).sum(:amount) || 0

      if @reference.nil?
        redirect "/withdrawal", :error => "Please input your paypal email address"
      end

      if @balance > 0
        withdrawal = Withdrawal.create(:user_id => session[:user][:id], :amount => @balance, :type => @type, :reference => @reference)
        Transaction.where(:user_id => session[:user][:id], :withdrawal_id => nil).update(:withdrawal_id => withdrawal[:id])
      end

      render "withdraw"
    end

    get '/withdrawals' do
      @balance = Transaction.where(:user_id => session[:user][:id], :withdrawal_id => nil).sum(:amount) || 0
      @withdrawals = Withdrawal.where(:user_id => session[:user][:id]).order(:id).paginate(@page, 5).reverse
      render "withdrawals"
    end

    get '/withdrawal/paid/(:id)' do
      model = Withdrawal[params[:id]]
      if !model.nil? && model.update(:status => 'paid')
        redirect("/dashboard/payouts", :success => 'Withdrawal has been set to paid!')
      else
        redirect("/dashboard/payouts", :success => 'Sorry, there was a problem!')
      end
    end

    get '/payouts' do
      @withdrawals = Withdrawal.where().order(:id).paginate(@page, 15).reverse
      render "payouts"
    end

    # my routes
    get '/my/account' do
      params[:id] = session[:user][:id]
      @user = User[params[:id]]
      if session[:user][:role] == "admin"
        @invitees = Invite.where(:user_id => params[:id]).all
      else
        @invitees = Invite.where(:user_id => session[:user][:id]).all
      end
      render "user"
    end

    get '/my/company' do
      @company = Company.where(:user_id => session[:user][:id]).first
      params[:id] = @company[:id] || nil
      render "company"
    end

    get '/my/companies' do
      only_for("company")
      @companies = Company.where(:user_id => session[:user][:id]).order(:rank).paginate(@page, 5)
      render "companies"
    end

    # user routes
    get '/users' do
      only_for("admin")
      @users = User.order(:id).paginate(@page, 5000).reverse
      render "users"
    end

    # user ajax
    get '/users/ajax' do
      only_for("admin")
      search = params[:search]

      @users = User.where(Sequel.ilike(:email, '%'+search+'%')).or(Sequel.ilike(:first_name, '%'+search+'%')).or(Sequel.ilike(:last_name, '%'+search+'%')).order(:id).paginate(@page, 50).reverse
      partial "partials/users"
    end

    get '/user/(:id)' do
      @user = User[params[:id]]
      if session[:user][:role] == "admin"
        @invitees = Invite.where(:user_id => params[:id]).all
      else
        @invitees = Invite.where(:user_id => session[:user][:id]).all
      end

      render "user"
    end

    post '/user/save/(:id)' do
      data = params[:user]

      # validate fields
      rules = {
        :first_name => {:type => 'string', :required => true},
        # :email => {:type => 'email', :required => true},
        :password => {:type => 'string', :min => 6, :confirm_with => :password_confirmation},
      }
      validator = Validator.new(data, rules)

      if !validator.valid?
        msg = validator.errors
        flash.now[:error] = msg[0][:error]
        if params[:id].blank?
          @user = User.create(data)
        else
          @user = User[params[:id]].set(data)
        end
      else

        # create or update
        if params[:id].blank? # create
          @user = User.register_with_email(data, data[:role])
          if @user
            redirect("/dashboard/users", :success => 'Record has been created!')
          else
            flash.now[:error] = 'Sorry, there was a problem creating'
          end
        else # update
          @user = User[params[:id]]

          if !@user.nil?

            # if user activated from beta
            beta_activated = false
            if @user[:role] == "pending_marketer" && data[:role] == "marketer"
              beta_activated = true
            end

            # if user activated from beta
            w9_uploaded = false
            if @user[:w9_status] != "pending" && data[:role] == "pending"
              w9_uploaded = true
            end

            @user = @user.set(data)

            if params[:generate_token] == "1"
              @user.access_token = ''
            end

            if @user.save

              # if updating current user, refresh session and reload page
              if session[:user][:id] == @user[:id]
                session[:user] = @user.values
              end

              # send out beta activation email
              if beta_activated
              

                mailjet({
                  :to => @user[:email],
                  :subject => "You've Been Accepted!",
                  :template => {
                  :id => 37296,
                  }                  
                })
                
              end

              # send out w9 uploaded email
              if !data[:w9_url].blank? && data[:w9_url].class == Hash
                from = 'support@markett.com'
                to = 'support@markett.com'
                subject = "[internal] W9 has been uploaded from #{@user[:first_name]} #{@user[:last_name]}"
                body = "#{@user[:first_name]} #{@user[:last_name]} has completed their W9. #{@site_url}#{@user[:w9_url]}\n"
                email({
                  :from => from, 
                  :to => to, 
                  :subject => subject, 
                  :body=> body,
                  :bcc => ['franky@markett.com', 'jae@markett.com', 'erin@markett.com', 'ronny@markett.com', 'hubdoc.magan+market.rtei8806@app.hubdoc.com']
                })
                
              end              

              redirect("/dashboard/user/#{@user[:id]}", :success => 'Record has been updated!')

            else
              flash.now[:error] = 'Sorry, there was a problem updating'
            end
          end
        end # end save

      end # end validator

      render "user"

    end

    get '/user/delete/(:id)' do
      model = User[params[:id]]
      if !model.nil? && model.destroy
        redirect("/dashboard/users", :success => 'Record has been deleted!')
      else
        redirect("/dashboard/users", :success => 'Sorry, there was a problem deleting!')
      end
    end
    # end user routes

    # company routes
    get '/companies' do
      if(session[:user][:role] == "company")
        redirect "/dashboard/my/company"
      end
      only_for("admin")
      @companies = Company.order(:rank).paginate(@page, 9999)
      render "companies"
    end

    get '/company/(:id)' do
      if(session[:user][:role] == "company")
        redirect "/dashboard/my/company"
      end
      only_for("admin")
      @company = Company[params[:id]]
      render "company"
    end

    get '/company/reorder/:id' do
      
      only_for("admin")
      
      id = params[:id]
      rank = params[:rank]
      
      company = Company[id]
      company[:rank] = rank
      company.save_changes

      res = {
        :id => id,
        :rank => rank
      }

      output(res)
    end

    post '/company/save/(:id)' do
      data = params[:company]

      # validate fields
      rules = {
        :company => {:type => 'string', :min => 2, :max => 256, :required => true},
      }
      validator = Validator.new(data, rules)

      if !validator.valid?
        msg = validator.errors
        flash.now[:error] = msg[0][:error]
      else

        # create or update
        if params[:id].blank? # create

          if data[:user_id].nil?
            data[:user_id] = session[:user][:id]
          end

          if session[:user][:role] == "company"
            data[:status] = 'pending'
          end

          @company = Company.create(data)
          if @company
            redirect("/dashboard/companies", :success => 'Record has been created!')
          else
            flash.now[:error] = 'Sorry, there was a problem creating'
          end
        else # update
          @company = Company[params[:id]]

          if !@company.nil?
            @company = @company.set(data)
            if @company.save
              redirect("/dashboard/company/#{@company.id}", :success => "Record has been updated!")
            else
              flash.now[:error] = 'Sorry, there was a problem updating'
            end
          end
        end # end save

      end # end validator

      render "company"

    end

    get '/company/delete/(:id)' do
      model = Company[params[:id]]
      if !model.nil? && model.destroy
        redirect("/dashboard/companies", :success => 'Record has been deleted!')
      else
        redirect("/dashboard/companies", :success => 'Sorry, there was a problem deleting!')
      end
    end
    # end company routes

    get '/company/:id/codes' do
      if session[:user][:role] == "company"
        company = Company.where(:user_id => session[:user][:id]).first
        params[:id] = company[:id]
      end

      @codes = Code.where(:company_id => params[:id]).order(:id).paginate(@page, 50)
      render "company_codes"
    end


    post '/company/:id/codes/add' do

      require 'csv'

      data = params[:code]

      # validate fields
      rules = {
        #:codes => {:type => 'string', :min => 2, :required => true},
      }
      validator = Validator.new(data, rules)

      if !validator.valid?
        msg = validator.errors
        flash[:error] = msg[0][:error]
      else # end validator

        codes = []

        # gather array of codes from CSV or textarea
        if !data[:csv_file].blank? && data[:csv_file].class == Hash
          csv_rows  = CSV.parse(data[:csv_file][:tempfile].read)
          csv_rows.each_with_index do |row, i|
            next if i == 0
            codes << row[0] + " " + row[1]
          end
        elsif !data[:codes].blank?
          codes = data[:codes].split(/\r?\n/)
        end

        # if codes detected
        if !codes.blank?
          added = 0
          codes.each do |row|
            line = row.strip.split(' ')
            code = line[0].upcase
            total_used = line[1].to_i
            company_id = params[:id]

            res = Code.add(company_id, code, total_used)
            added += res

          end

          if added > 0
            flash[:success] = added.to_s + " codes have been added"
          end

        else
          flash[:error] = "There were no codes to import"
        end

      end

      redirect "/dashboard/company/#{params[:id]}/codes"

    end



    # transaction routes
    get '/transactions' do
      only_for("admin")
      @transactions = Transaction.order(:id).paginate(@page, @per_page).reverse
      render "transactions"
    end

    get '/transaction/(:id)' do
      only_for("admin")
      @transaction = Transaction[params[:id]]
      render "transaction"
    end

    post '/transaction/save/(:id)' do
      data = params[:transaction]

      # validate fields
      rules = {
        :transaction => {:type => 'string', :min => 2, :max => 256, :required => true},
      }
      validator = Validator.new(data, rules)

      if !validator.valid?
        msg = validator.errors
        flash.now[:error] = msg[0][:error]
        if params[:id].blank?
          @transaction = Transaction.create(data)
        else
          @transaction = Transaction[params[:id]].set(data)
        end
      else

        # create or update
        if params[:id].blank? # create
          @transaction = Transaction.create(data)
          if @transaction
            redirect("/dashboard/transactions", :success => 'Record has been created!')
          else
            flash.now[:error] = 'Sorry, there was a problem creating'
          end
        else # update
          @transaction = Transaction[params[:id]]
          if !@transaction.nil?
            @transaction = @transaction.set(data)
            if @transaction.save
              flash.now[:success] = 'Record has been updated!'
            else
              flash.now[:error] = 'Sorry, there was a problem updating'
            end
          end
        end # end save

      end # end validator

      render "transaction"

    end

    get '/transaction/delete/(:id)' do
      model = Transaction[params[:id]]
      if !model.nil? && model.destroy
        redirect("/dashboard/transactions", :success => 'Record has been deleted!')
      else
        redirect("/dashboard/transactions", :success => 'Sorry, there was a problem deleting!')
      end
    end
    # end transaction routes


    # post routes
    get '/posts' do
      @posts = Post.order(:id).paginate(@page, @per_page).reverse
      render "posts"
    end

    get '/post/(:id)' do
      @post = Post[params[:id]]
      render "post"
    end

    post '/post/save/(:id)' do
      data = params[:post]

      # validate fields
      rules = {
        :user_id => {:type => 'numeric', :required => true},
        :title => {:type => 'string', :min => 2, :max => 256, :required => true},
        :content => {:type => 'string', :required => true},
      }
      validator = Validator.new(data, rules)

      if !validator.valid?
        msg = validator.errors
        flash.now[:error] = msg[0][:error]
        if params[:id].blank?
          @post = Post.create(data)
        else
          @post = Post[params[:id]].set(data)
        end
      else

        # create or update
        if params[:id].blank? # create
          @post = Post.create(data)
          if @post
            redirect("/dashboard/posts", :success => 'Record has been created!')
          else
            flash.now[:error] = 'Sorry, there was a problem creating'
          end
        else # update
          @post = Post[params[:id]]
          if !@post.nil?
            @post = @post.set(data)
            if @post.save
              flash.now[:success] = 'Record has been updated!'
            else
              flash.now[:error] = 'Sorry, there was a problem updating'
            end
          end
        end # end save

      end # end validator

      render "post"

    end

    get '/post/delete/(:id)' do
      model = Post[params[:id]]
      if !model.nil? && model.destroy
        redirect("/dashboard/posts", :success => 'Record has been deleted!')
      else
        redirect("/dashboard/posts", :success => 'Sorry, there was a problem deleting!')
      end
    end
    # end post routes

    # settings routes
    get '/settings' do
      only_for("admin")

      @settings = {}

      records = Setting.all
      records.each do |record|
        @settings[record[:name].to_sym] = record[:value]
      end

      render "settings"
    end

    post '/settings/save' do
      only_for("admin")

      params.each do |key, value|
        row = Setting.find(:name => key)
        if row.nil?
          Setting.create(:name => key, :value => value)
        else
          if value == ""
            value = nil
          end
          Setting.where(:name => key).update(:value => value, :updated_at => Time.now)
        end
      end

      redirect "/dashboard/settings", :success => "Settings saved"

    end

    get '/report' do
      stats = DB["
      SELECT co.user_id, co.company_id, MAX(u.first_name) as first, MAX(u.last_name) as last, MAX(u.city) as city, MAX(c.company) as company, SUM(co.num_used) as num_used
FROM Codes co
LEFT JOIN Users u ON u.id = co.user_id
LEFT JOIN Companies c ON c.id = co.company_id
GROUP BY co.user_id, co.company_id
ORDER BY co.user_id, co.company_id
"].all

      @reduced = stats.reduce({}) do |byUserId, n|
        if(n[:user_id].nil?)
          byUserId
        else
          company = {
              :name => n[:company],
              :num_used => n[:num_used]
          }
          if(byUserId[n[:user_id]])
            byUserId[n[:user_id]][:companies].push(company)
          else
            byUserId[n[:user_id]] = {
                :user => {
                    :name => n[:first] + ' ' + n[:last],
                    :city => n[:city]
                },
                :companies => [company]
            }
            byUserId
          end
        end
      end

      render 'report'
    end

    # payout routes
    get '/payout' do

      # @payment = Payment.new({
      #   :intent => "sale",
      #   :payer => {
      #     :payment_method => "credit_card",
      #     :funding_instruments => [{
      #       :credit_card => {
      #         :type => "visa",
      #         :number => "4417119669820331",
      #         :expire_month => "11", :expire_year => "2018",
      #         :cvv2 => "874",
      #         :first_name => "Joe", :last_name => "Shopper",
      #         :billing_address => {
      #           :line1 => "52 N Main ST",
      #           :city => "Johnstown",
      #           :state => "OH",
      #           :postal_code => "43210", :country_code => "US" }}}]},
      #   :transactions => [{
      #     :amount => {
      #       :total => "7.47",
      #       :currency => "USD",
      #       :details => {
      #         :subtotal => "7.41",
      #         :tax => "0.03",
      #         :shipping => "0.03"}},
      #     :description => "This is the payment transaction description." }]})

      # res = @payment.create

      # abort


      PayPal::SDK.configure(
        :mode => "sandbox", # "sandbox" or "live"
        :client_id => "AbuiPdnpCPRZ6iQ6iZjY69kdBb-AYSMASGB1VBmFUhIQmNI7VJeiKJsWyYm9G5OF2-zNwdf0RaxEOxCQ",
        :client_secret => "EGFWv2tsrJF3hsvrDbD7hoGMmjt4kT9QVgcnWVzc1vLZur8EUDxbDkExMwgMZjS6X6lHpz27J7VAgYzm",
        :ssl_options => { } )
      
      @payout = Payout.new(
        {
          :sender_batch_header => {
            :sender_batch_id => SecureRandom.hex(8),
            :email_subject => 'You have a Payout!',
          },
          :items => [
            {
              :recipient_type => 'EMAIL',
              :amount => {
                :value => '1.0',
                :currency => 'USD'
              },
              :note => 'Thanks for your patronage!',
              :receiver => 'shirt-supplier-one@mail.com',
              :sender_item_id => Time.now.to_i,
            }
          ]
        }
      )

      begin
        @payout_batch = @payout.create
        logger.info "Created Payout with [#{@payout_batch.batch_header.payout_batch_id}]"
      rescue ResourceNotFound => err
        logger.error @payout.error.inspect
      end
    end

    # end setting routes

    get '/leaderboard' do
      render 'leaderboard'
    end

    ### end of routes ###

    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Not Found']
    end


    ### utility methods ###
    def output(val)
      case val
      when String
        if val.is_json?(val)
          content_type :json
          val.to_json
        else
          val
        end
      when Hash
        content_type :json
        val.to_json
      when Array
        content_type :json
        val.to_json
      when Fixnum
        val
      else
        val
      end
    end



  end # end class

end # end module
