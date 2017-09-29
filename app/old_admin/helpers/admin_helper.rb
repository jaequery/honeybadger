# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class AdminApp
    module AdminHelper

      def paginate(model)
        will_paginate model, renderer: BootstrapPagination::Sinatra, :previous_label => '&laquo;', :next_label => '&raquo;'
      end

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

    end

    helpers AdminHelper
  end
end
