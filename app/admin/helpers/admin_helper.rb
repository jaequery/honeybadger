# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class AdminApp
    module AdminHelper

      def paginate(model)
        will_paginate model, renderer: BootstrapPagination::Sinatra, :previous_label => '&laquo;', :next_label => '&raquo;'
      end

      def only_for(role)
        redirect("/") if session[:user_id].nil? 
        user = User[session[:user_id]]

        access = false

        if !user[:role].blank?

          if role.class == Array
            access = true if role.include? user[:role]
          else
            access = true if user[:role] == role
          end

        end

        redirect("/") if access == false
      end

      def set_active_on_match(regex)
        current_url = env["REQUEST_URI"]
        if current_url.match(regex)
          return "active"
        else
          return ""
        end
      end

    end

    helpers AdminHelper
  end
end
