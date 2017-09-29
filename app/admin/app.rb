# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class AdminApp < Padrino::Application

    register Sinatra::MultiRoute
    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra

    enable :sessions
    enable :reload
    layout :admin

    ### this runs before all routes ###
    before do
      
      only_for(["admin", "developer"])

      @title = config('site_title') || "Honeybadger CMS"
      @page = (params[:page] || 1).to_i
      @per_page = params[:per_page] || 25

      if !session[:user_id].blank?
        @current_user = User[session[:user_id]]
      end



    end
    ###

    ### routes ###
    get '/' do
      redirect "/admin/users"
      render "index"
    end

    # user routes
    get '/users' do

      @users = User.order(:id)

      if !params[:search].blank?
        @users = @users.where("LOWER(email) LIKE LOWER('%#{params[:search]}%') OR LOWER(first_name) LIKE LOWER('%#{params[:search]}%') OR LOWER(last_name) LIKE LOWER('%#{params[:search]}%')")
      end

      @users = @users.order(:created_at).paginate(@page, @per_page).reverse
      render "users"
    end

    get '/user/(:id)' do
      @user = User[params[:id]]
      render "user"
    end

    get '/myaccount' do
      params[:id] = session[:user][:id]
      @user = User[params[:id]]
      render "user"
    end

    post '/user/save/(:id)' do
      data = params[:user]

      # validate fields
      rules = {
        :first_name => {:type => 'string', :required => true},
        :email => {:type => 'email', :required => true},
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
            redirect("/admin/users", :success => 'Record has been created!')
          else
            flash.now[:error] = 'Sorry, there was a problem creating'
          end
        else # update
          @user = User[params[:id]]
          if !@user.nil?
            @user = @user.set(data)

            if @user.save

              flash.now[:success] = 'Record has been updated!'

              # if updating current user, refresh session and reload page
              if session[:user][:id] == @user[:id]
                session[:user] = @user.values
              end

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
        redirect("/admin/users", :success => 'Record has been deleted!')
      else
        redirect("/admin/users", :success => 'Sorry, there was a problem deleting!')
      end
    end

    post '/user/bulk_action' do
      if params[:cmd] == 'delete' && User.where(:id => params[:ids]).destroy
        return { :status => 'ok', :code => 200}.to_json
      else
        return { :status => 'error', :code => 500}.to_json
      end
    end
    # end user routes


    # products
    get '/products' do
      if !params[:search].blank?
        search = params[:search]
        @products = Product
        .where("LOWER(name) LIKE LOWER('%#{search}%') OR LOWER(sku) LIKE LOWER('%#{search}%')").reverse
      elsif params[:need_review] == "1"
        @products = Product
        .where("sku = '' OR categories IS NULL OR description IS NULL")
        .order(:displayed_at).reverse

      elsif params[:category].present?
        @category = params[:category]

        @products = Product
        .filter_category(@category)
        .order(:displayed_at).reverse

      elsif params[:find_dupes] == "1"
        @products = Product
        .order(:sku)

      else
        @products = Product
        .order(:displayed_at).reverse
      end

      render "products"
    end

    # products

    get '/product/(:id).json' do
      content_type :json
      @product = Product[params[:id]]
      if @product
        return {
          :status => 'ok',
          :code => 200,
          :product => @product
          }.to_json
        else
          return {
            :status => 'produt not found',
            :code => 404,
            }.to_json
          end

        end

        get '/product/search' do
          content_type :json
          product = Product.where(:sku => params[:sku].upcase).order(:activated_on).last
          if !product.blank?
            return {:status => 'ok', :code => 200, :product => product}.to_json
          else
            return {:status => 'not found', :code => 404 }.to_json
          end
        end

        get '/product/(:id)' do
          @product = Product[params[:id]]
          render "product"
        end

        post '/product/save/(:id)' do

          content_type :json

          data = params[:product] || {}

          if !data[:categories].blank?
            data[:categories] = data[:categories].to_json
          else
            data[:categories] = [].to_json
          end

          if !data[:colors].blank?
            data[:colors] = data[:colors].values.to_json
          else
            data[:colors] = [].to_json
          end

          if !data[:images].blank?
            if data[:main_image].blank?
              data[:main_image] = data[:images][0]
            end
            data[:images] = data[:images].to_json
          else
            data[:images] = [].to_json
          end

          if data[:made_in].blank?
            data[:made_in] = "Imported"
          end

          if data[:label].blank?
            data[:label] = "Labeled"
          end

      if params[:id].blank? # create
        @product = Product.create(data)
        if @product
          return { :status => 'A new record has been created', :code => 200, :product => @product}.to_json
        else
          return { :status => 'Sorry, there was a problem creating the record', :code => 500 }.to_json
        end

      else # update
        @product = Product[params[:id]]

        if !@product.nil?
          @product = @product.set(data)
          if @product.save
            return { :status => 'Record sucessfully updated', :code => 200, :product => @product}.to_json
          else
            return { :status => 'Sorry, there was a problem updating the record', :code => 500 }.to_json
          end
        end

      end # end save

    end

    get '/product/delete/(:id)' do
      model = Product[params[:id]]
      if !model.nil? && model.destroy
        redirect("#{params[:redir]}", :success => 'Record has been deleted!')
      else
        redirect("#{params[:redir]}", :success => 'Sorry, there was a problem deleting!')
      end
    end

    post '/product/bulk_action' do
      if params[:cmd] == 'delete' && Product.where(:id => params[:ids]).destroy
        return { :status => 'ok', :code => 200}.to_json
      else
        return { :status => 'error', :code => 500}.to_json
      end
    end

    post '/product/display/(:id)' do
      content_type :json

      @product = Product[params[:id]]

      if !@product.nil?
        @product = @product.set(displayed_at: params[:displayed_at])
        if @product.save
          return { :status => 'Record sucessfully updated', :code => 200, :product => @product}.to_json
        else
          return { :status => 'Sorry, there was a problem updating the record', :code => 500 }.to_json
        end
      end
    end
    # end post routes

    # order routes
    get '/orders' do
      order = Order.order(:id)
      order = order.where(:ref => params[:ref]) if !params[:ref].blank?   #ref search

      @opt_filter = 'ordernum'
      if !params[:id].blank?
        order = order.where(:id => params[:id]) if !params[:id].blank?      #Id search
        @opt_filter = 'ordernum'
        @txt_key = params[:id]
      end

      if !params[:company].blank?
        order = order.where(user: User.where('company ILIKE ?', '%' + params[:company] + '%'))
        @opt_filter = 'company'
        @txt_key = params[:company]
      end

      if !params[:status].blank?
        splt = params[:status].split(',')
        order = order.where(:status => splt) if !params[:status].blank?
      end
      @orders = order.all.reverse
      @orderstatus = params[:status];
      render 'orders'
    end

    get '/order/:order_id' do
      @order = Order[params[:order_id]]

      render 'order'
    end

    post '/order/:id' do
      content_type :json
      order = Order[params[:id]]
      return { :status => 'error', :code => '404' } if order.blank?

      order = order.update(params)
      return { :status => 'ok', :code => 200, :order => order }.to_json
    end

    get '/new-order/(:id)' do
      @order = nil
      @order = Order[params[:id]] if !params[:id].blank?
      render 'new-order', :layout => false
    end

    post '/new-order' do
      content_type :json

      data = {
        :user_id => params[:order][:user][:id],
        :comments => params[:order][:comments],
        :comments_staff => params[:order][:comments_staff],
        :ref => params[:order][:ref],
        :type => params[:order][:type],
        :items => params[:order][:items].to_json,
        :shipping => params[:order][:user][:shipping].to_json,
        :billing => {
          :address => params[:order][:user][:address],
          :address2 => params[:order][:user][:address2],
          :city => params[:order][:user][:city],
          :state => params[:order][:user][:state],
          :zip => params[:order][:user][:zip],
          :country => params[:order][:user][:country],
          }.to_json
        }

        order = Order.create(data)

        if order
          return { :status => 'ok', :code => 200, :order => order }.to_json
        else
          return { :status => 'error', :code => 500 }.to_json
        end

      end

      get '/edit-order/:id' do
        @order = Order[params[:id]]
        
        if @order.items.class == Sequel::Postgres::JSONBHash
          items = []
          @order.items.each{|k, item|
            items << item
          }        
          @order.items = items
        end

        @user = @order.user
        render 'edit-order', :layout => false
      end

      post '/edit-order/:id' do
        content_type :json

        data = {
          :comments => params[:order][:comments],
          :comments_staff => params[:order][:comments_staff],
          :ref => params[:order][:ref],
          :items => params[:order][:items].to_json,
          :shipping => params[:order][:shipping].to_json,
        }
        res = Order.where(:id => params[:id]).update(data)

        if res
          return { :status => 'ok', :code => 200, :order => Order[params[:id]] }.to_json
        else
          return { :status => 'error', :code => 500 }.to_json
        end

      end

      get '/invoice/:id/:type' do
        @order = Order[params[:id]]
        @title = "Listicle Invoice ##{@order.id}"
        render 'invoice', :layout => :plain
      end

      get '/user/search/:search' do
        search = params[:search]
        @user = User.where(:id => search).first

        content_type :json

        if @user.blank?
          return {
            :status => 'user not found',
            :code => 404
            }.to_json
          else

            return {
              :status => 'ok',
              :code => 200,
              :user => @user
              }.to_json

            end

          end

          get '/convert-colors' do
            content_type :json
            res = []
            Product.all.each {|product|
              if product.colors

                if product.colors[0].class == String


                  new_colors = product.colors.map{|color|
                    { :name => color, :sku => product.sku + '-' + color }
                  }
            #product.where(:id => product.id).update(:colors => new_colors.to_json)


            res << {
              :id => product.id,
              :old_colors => product.colors,
              :new_colors => new_colors
            }


          end

        end

      }

      return res.to_json
    end

    get '/get-barcodes' do
      #content_type :json

      list = ''

      products = Product.where(:stock_status => 'Active').all
      products.each{|product|
        product.colors.each{|color|
          list += product[:sku] + '-' + color + ", #{product[:price]}\n"
        }
      }
      list
    end

    get '/fg-all-products' do
      render 'fg-all-products'
    end

    post '/fg-all-products' do
      require 'csv'

      Product.where("1=1").update(:stock_status => 'Inactive')

      if !params[:active_items_file][:tempfile].blank?
        file_data = params[:active_items_file][:tempfile].read.gsub(/" /, '')

        csv_rows  = CSV.parse(file_data)

        csv_rows.each_with_index do |row, i|
          next if i == 0 || (row[0].blank? && row[1].blank?)

          sku = row[2]

          # remove characters at end of sku
          sku = sku[0...-3] if !sku.last(3).to_s.match(/[^A-Za-z]/)
          sku = sku[0...-2] if !sku.last(2).to_s.match(/[^A-Za-z]/)
          sku = sku[0...-1] if !sku.last(1).to_s.match(/[^A-Za-z]/)

          prod = Product.where(:sku => sku).order(:activated_on).last

          category = row[3].titleize
          if prod[:categories].blank?
            categories = []
          else
            categories = prod[:categories]
          end
          categories = categories.push(category).uniq if !category.blank?

          data = {
            # :description => row[18].to_s,
            :available_on => !row[9].blank? ? row[9] : nil,
            :category => category,
            :categories => categories.to_json,
            :pack_size => row[5],
            :fabric => row[15],
            :label => 'Labeled',
            :colors => row[16].split(', ').to_json,
            :pack => row[6],
            :pack_qty => row[7],
            :made_in => row[11],
            :stock_status => 'Active',
            :refid => row[0],
          }

          if !prod.blank?

            Product.where(:sku => sku).update(data)

          else
            #Product.create(data)
          end
        end
      end

      content_type :json
      return { :status => 'ok', :code => 200, :message => "imported items"}.to_json

    end

    get '/fg-new-products' do
      render 'fg-new-products'
    end

    post '/fg-new-products' do

      json = JSON.parse(params[:json])
      category = params[:category]

      @items = json["data"]["items"]
      @imported = []
      @excluded = []

      @items.reverse.each do |item|
        prodname = item["productName"].gsub("-Clone", "")
        exploded = prodname.split('-')

        sku = exploded[exploded.length - 1] ? exploded[exploded.length - 1].strip : ''
        name = exploded.take( exploded.length - 1 ).join('-').strip

        # remove characters at end of sku
        sku = sku[0...-3] if !sku.last(3).to_s.match(/[^A-Za-z]/)
        sku = sku[0...-2] if !sku.last(2).to_s.match(/[^A-Za-z]/)
        sku = sku[0...-1] if !sku.last(1).to_s.match(/[^A-Za-z]/)

        image_root = item["imageUrlRoot"]
        images = item["images"].map do |image|
          image_root + "/Vendors/listicle/ProductImage/large/" + image
        end

        data = {
          :category => category,
          :name => name,
          :sku => sku,
          :refid => item["pid"],
          :price => item["price"],
          :images => images.to_json,
          :activated_on => item["activatedOn"],
          :available_on => item["availableOn"],
          :main_image => images[0],
        }

        # check if it already exists, if not, create it
        product = Product.where(:sku => data[:sku]).first

        if product.blank?
          p = Product.create(data)
          @imported.push(p)
        else
          if !category.blank?
            product[:categories] = [] if product[:categories].blank?
            data[:categories] = product[:categories].push(category).uniq.to_json
          end
          data = {
            :category => category,
            :name => name,
            # :sku => sku,
            #:refid => item["pid"],
            :price => item["price"],
            :images => images.to_json,
            :activated_on => item["activatedOn"],
            :available_on => item["availableOn"],
            :main_image => images[0],
          }
          p = product.update(data)
          #@excluded.push(product)
        end
      end



      # ProductRanking.where(:category => category).destroy()
      # c = 0
      # @items.each do |item|
      #   exploded = item["productName"].split('-')
      #   sku = exploded[1] ? exploded[1].strip : ''
      #   c += 1
      #   product = Product.where(:sku => sku).first
      #   if product

      #   end
      # end


      render 'fg-new-products'
    end


    # settings routes
    get '/settings' do
      @settings = Setting.order(:id).reverse.all
      @settings = Setting[1]
      render "settings"
    end

    post '/settings/save', :provides => :js do
      data = params
      abort

      msg
    end
    # end setting routes


    # temp util routes
    get '/extract' do
      render "extract"
    end

    post '/extract' do

      return "sku is required" if params[:sku].blank?

      colors = params[:colors].split(',').map{|c| c.strip }
      data = {
        :description => params[:description],
        :fabric => params[:fabric],
        :made_in => params[:made_in],
        :label => params[:label],
        :stock_status => params[:stock_status],
        :colors => colors.to_json,
        :price => params[:price],
        :old_price => params[:old_price],
      }

      res = Product.where(:sku => params[:sku]).update(data)

      redirect "/admin/extract", :sucecss => 'updated'

      if res == 1
        return "updated"
      else
        return "error"
      end
    end

    # import temp
    get '/import' do
      import_products = JSON.parse(File.read("app/scrape/all.json"))

      import_products.reverse.each do |product|

        data = {
          :category => product["category"],
          :name => product["name"],
          :sku => product["sku"],
          :refid => product["pid"],
          :price => product["price"],
          :images => product["images"].to_json,
          :arrived_on => product["arrived_on"],
          :available_on => product["available_on"],
        }

        # check if it already exists, if not, create it
        product = Product.where(:sku => data[:sku], :category => data[:category]).first
        if product.blank?
          Product.create(data)
          p "product saved - #{data[:sku]} - #{data[:name]}"
        end
      end


      abort

      content_type :json
      return data

    end


    get '/fix-orders' do
      res = ''
      Order.all.each{|order|
        order.items.each{|item|
          abort
          res += item[1]["product"]["name"].to_s
        }
      }
      return res
    end


    get '/import-customers' do
      require 'csv'
      csv_rows  = CSV.read("sample/customers.csv")
      csv_rows.each_with_index do |row, i|

        next if i == 0 || row[2].blank?

        company = row[2].strip
        name = nil
        name = row[24].strip.split(' ') if !row[24].blank?
        first_name = nil
        last_name = nil
        first_name = row[14].strip.capitalize if !row[14].blank?
        last_name = row[16].strip.capitalize if !row[16].blank?
        email = nil
        email = row[10].downcase.strip if !row[1].blank?
        shipping_name = nil
        shipping_first_name = nil
        shipping_last_name = nil
        if !row[46].blank?
          shipping_name = row[46].strip.split(' ')
          shipping_first_name = shipping_name[0]
          shipping_last_name = shipping_name[shipping_name.length - 1]
        end

        data = {
          :company => company,
          :first_name => first_name,
          :last_name => last_name,
          :email => email,
          :phone => row[18],
          :fax => row[22],

          :role => 'users',
          :provider => 'email',
          :refid => email,
          :status => 'pending_activation',
          :username => email,
          :newsletter => true,
          :hear_about_us_option => 'Other',
          :hear_about_us_other => 'quickbooks',

          :address => row[26],
          :city => row[28],
          :state => row[30],
          :zip => row[32],
          :country => row[42],
          :created_at => "2017-01-02",

          :shipping_first_name => shipping_first_name,
          :shipping_last_name => shipping_last_name,
          :shipping_address => row[48],
          :shipping_address => row[5],
          :shipping_city => row[50],
          :shipping_state => row[52],
          :shipping_zip => row[54],
          :shipping_country => row[56],

          :addresses => [
            {
              :label => 'billing',
              :name => name,
              :address => row[26],
              :address2 => nil,
              :city => row[28],
              :state => row[30],
              :zip => row[32],
              :country => row[42] || 'US',
              },
              {
                :label => 'shipping',
                :name => row[46],
                :address => row[48],
                :address2 => nil,
                :city => row[50],
                :state => row[52],
                :zip => row[54],
                :country => row[56] || 'US',
              }
              ].to_json
            }


            user = User.where(Sequel.ilike(:company, company)).first
            if user.blank?
              begin
                User.create(data)
              rescue => e

              end

            end


          end

          return "all finished"

        end


        get '/import-other-products' do
          render 'import-other-products'
        end

        post '/import-other-products' do

          require 'csv'
          if !params[:items_file][:tempfile].blank?
            file_data = params[:items_file][:tempfile].read.gsub(/" /, '')
            csv_rows  = CSV.parse(file_data)
            csv_rows.each_with_index do |row, i|

              x = row[0].split('-')
              sku = x[0].upcase
              color = x[1].titleize
              name = 'New item'
              price = BigDecimal(row[1])
              prod = Product.where(:sku => sku).first

              if prod.blank?

                Product.create({
                  :name => name,
                  :sku => sku,
                  :colors => [].push(color).to_json,
                  :price => price,
                  :category => 'Other',
                  :categories => ['Other'].to_json,
                  :pack => '2, 2, 2',
                  :pack_qty => '6',
                  :pack_size => 'S, M, L',
                  :main_image => '',
                  :images => [].to_json,
                  })

              else

                colors = []
                colors = prod[:colors] if !prod[:colors].blank?
                prod.update(
                  :colors => colors.push(color).uniq.to_json,
                  :price => price,
                  )

              end

        end # csv_rows
      end # if

      return "all done"
    end

    ### end of routes ###


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
