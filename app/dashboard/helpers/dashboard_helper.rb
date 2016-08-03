# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class DashboardApp
    module DashboardHelper

      def only_for(role)
        if session[:user].nil? || (!session[:user][:role].blank? && session[:user][:role] != role)
          redirect("/")
        end
      end

      def set_active_on_match(regex)
        current_url = env["REQUEST_URI"]
        if current_url.match(regex)
          return "active"
        else
          return ""
        end
      end

      def setting(name)
        # do lookup
        row = Setting.where(:name => name).first[:value]

        # if not found, get settings from config/apps.rb
        if row.nil?
          row = settings.send(name) rescue nil
        end

        if row[0] == '{'
          row = eval(row)
        end

        return row      
      end

    end

    helpers DashboardHelper
  end
end
