# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class AdminApp
    module AdminHelper

      def output_js_success(msg)
        js = "$('#flash').hide();"
        js += "$('.form-group').attr('class','form-group');"
        js += "swal('Success!', '#{msg}', 'success');"
      end

      def output_js_error(msg)
        js = "$('#flash').hide();"
        js += "$('.form-group').attr('class','form-group');"
        js += "swal('Ooops, there was a problem ...', '#{msg}', 'error');"
      end

      def output_js_validator(errors, form_model='')
        js = "$('#flash').hide();"
        js += "$('.form-group').attr('class','form-group');"

        # get error messages
        error_messages = []
        errors.each do |error|
          error_messages << "#{error[:name]} #{error[:error]}"
        end

        # show sweet alert (use below instead)
        #js += "swal('Validation error!', '#{error_messages.join("\\n")}', 'error');\n"

        # show input form errors
        if !form_model.blank?
          errors.each do |error|
            js += "$('##{form_model}_#{error[:name]}').closest('.form-group').attr('class', 'form-group').addClass('has-error');\n"
          end
        end

        # show flash message
        js += "$('#flash').show();"
        js += "$('#flash .flash_title').text('Validation Error');"
        js += "$('#flash .flash_message').html('#{error_messages.join("<br>")}');"

        # return msg
        js
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
