#module Honeybadger

  class Validator

    attr_reader :errors

    # params, hash to check rules against
    # rules, rules to check hash against
    def initialize (params, rules = nil)
      @errors = []
      @params = params

      # run validate
      validate(params, rules)

    end

    # validates based on fields map
    def validate(params, rules)

      # go over each rules
      if rules

        rules.each do |rule, conditions|

          param_key = rule
          param_value = params[rule]

          if param_value.blank? && !conditions[:required].present?
            next
          end

          # puts conditions
          conditions.each do |condition, condition_value|
            if condition.to_s == "type"
              method = "check_type_#{condition_value}".to_sym
            else
              method = "check_#{condition}".to_sym
            end

            self.send(method, param_key, param_value, condition_value)

          end # end conditions.each

        end #end rules.each
      end

      return self

    end

    # adds to errors
    def has_error (name, error)
      @errors.push({:name => name, :error => error})
    end

    # returns if passed validation
    def valid?
      if @errors.empty?
        return true
      else
        return false
      end
    end

    ### validators ###

    def check_required (key, value, condition)
      if value.present? || value == false
        return true
      else
        has_error(key, 'required field')
        return false
      end
    end

    def check_type_numeric (key, value, condition)
      string_val = value.to_s
      if string_val.is_number?
        return true
      else
        has_error(key, 'is not numeric')
        return false
      end
    end

    def check_type_string(key, value, condition)
      if value.is_a? String
        return true
      else
        has_error(key, 'is not a string')
        return false
      end
    end

    def check_type_email(key, value, condition)
      if value.is_a? String
        return true
      else
        has_error(key, 'is not a string')
        return false
      end
    end

    def check_type_alnum(key, value, condition)
      valid = value.to_s =~ /\A\p{Alnum}+\z/

      if valid
        return true
      else
        has_error(key, 'not alphanumeric')
        return false
      end
    end

    def check_type_cc(key, value, condition)
      type = Util::cc_to_type(value.to_s)

      if type
        return true

      else
        has_error(key, 'not a credit card number')
        return false
      end

    end

    def check_type_currency(key, value, condition)
      if key.nil? || value.nil?
        return false
      end
      name = Util::currency_name_to_code(value)
      if name == false
        has_error(key, 'unknown currency')
      end
      return false
    end

    def check_type_email(key, value, condition)
      if key.nil? || value.nil?
        return false
      end
      valid = Util::valid_email?(value)
      if !valid
        has_error(key, 'invalid email address')
      end
      return false
    end

    def check_confirm_with(key, value, condition)
      if (value == @params[condition])
        return true
      else
        has_error(key, "password needs to match with confirmation password")
        return false
      end
    end

    def check_min (key, value, condition)
      if (value.to_s.length >= condition)
        return true
      else
        has_error(key, "needs a minimum of #{condition} characters")
        return false
      end
    end

    def check_max (key, value, condition)
      if (value.to_s.length <= condition)
        return true
      else
        has_error(key, 'max length')
        return false
      end
    end

  end # end class


#end
