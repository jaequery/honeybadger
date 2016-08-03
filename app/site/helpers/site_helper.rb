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
    helpers SiteHelper
  end
end
