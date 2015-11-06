# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class Admin
    module AdminHelper

      def config(name)
        Config.where(:name => name).first[:value]
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
