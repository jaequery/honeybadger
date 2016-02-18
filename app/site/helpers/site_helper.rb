# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class SiteApp
    module SiteHelper

      def flash_alert(flash)
        html = ''
        if !flash.blank?
          type = flash.keys[0]
          html = "
<div class='alert alert-dismissible alert-#{type}'>
                <button type='button' class='close' data-dismiss='alert'>&times;</button>
                <h4>Warning!</h4>
                <p></p>
              </div>
"

          html
        end
      end

    end

    helpers SiteHelper
  end
end
