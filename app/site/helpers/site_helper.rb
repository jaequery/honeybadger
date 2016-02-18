# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class SiteApp
    module SiteHelper

      def flash_messages(flash)
        html = ''
        if !flash[:notice].nil?
          html += '<div class="message">'
          html += flash[:notice]
          html += '</div>'
        end
        html
      end


    end

    helpers SiteHelper
  end
end
