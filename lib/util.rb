# coding: utf-8
module Util

  def self.to_currency (value)
    number_to_currency(value)
  end

  def self.output(output)
    if output.class == Hash
      output = convert_bd_in_hash(output)
      res = JSON.generate(output)
    end

    return res

  end

  def self.cc_to_type(cc_num)
    if cc_num.to_s =~ /^5[1-5][0-9]{14}$/
      return 'mast'
    end

    if cc_num.to_s =~ /^4[0-9]{12}([0-9]{3})?$/
      return 'visa'
    end

    if cc_num.to_s =~ /^3[47][0-9]{13}$/
      return 'amex'
    end


    if cc_num.to_s =~ /^3(0[0-5]|[68][0-9])[0-9]{11}$/
      return 'dine'
    end


    if cc_num.to_s =~ /^6011[0-9]{12}$/
      return 'disc'
    end


    if cc_num.to_s =~ /^(3[0-9]{4}|2131|1800)[0-9]{11}$/
      return 'jcb'
    end

    return false
  end

  def self.generate_token
    return Digest::SHA1.hexdigest([Time.now, rand].join)
  end

  def self.ip2long(ip)
    if ip.nil?
      return 0
    end

    long = 0
    ip.split(/\./).each_with_index do |b, i|
      long += b.to_i << (8*i)
    end

    return long
  end

  def self.long2ip(long)
    ip = []
    4.times do |i|
      ip.push(long.to_i & 255)
      long = long.to_i >> 8
    end
    ip.join(".")
  end

  def self.get_salt
    return '2i9jsdf0923jsdfkj209jfskes'
  end

  def self.encrypt(str)
    password = get_salt
    encrypted = AESCrypt.encrypt(str, password)
    encoded = UrlSafeBase64.encode64(encrypted)
    return encoded
  end

  def self.decrypt(encrypted_str)
    decoded = UrlSafeBase64.decode64(encrypted_str)
    password = get_salt
    decrypted = AESCrypt.decrypt(decoded, password)
    return decrypted
  end

  def self.convert_bd_in_hash(hash)
    hash = hash.map_values do |v|
      if v.class == BigDecimal
        v.truncate.to_s + '.' + sprintf('%02d', (v.frac * 100).truncate)
      else
        v
      end
    end
    return hash
  end

  def self.currency_name_to_code(name = 'USD')
    name = name.upcase

    # needs to be 3 characters or shorter
    if name.length > 3
      return false
    end

    begin
      money = Money.new(0, name)
      code = money.currency.iso_numeric
      return code
    rescue
      return false
    end

  end

  def self.currency_code_to_name(code = '840')
    currency = Money::Currency.find_by_iso_numeric(code)
    return currency.iso_code
  end

  def self.card_type(card_num)
    require 'credit_card_validations/string'
    number = card_num
    detector = CreditCardValidations::Detector.new(number)
    card_type = nil
    if !detector.brand.nil?
      card_type = detector.brand.to_s
    end
    return card_type
  end

  def self.mask_cc(card_num)
    return card_num.to_s[0..5] + card_num.to_s[-4..-1]
  end

  def self.sha(str)
    return Digest::SHA1.hexdigest(str)
  end

  def self.ip_to_country_alpha2(ip)
    c = GeoIP.new('lib/geoip/GeoIP.dat').country(ip)
    return c[:country_code2]
  end

  def self.country_alpha2_to_numeric(country_alpha2)
    c = Country.new(country_alpha2)
    code = c.number
    return code
  end

  def self.valid_email?(email)
    (email =~ /^(([A-Za-z0-9]*\.+*_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\+)|([A-Za-z0-9]+\+))*[A-Z‌​a-z0-9]+@{1}((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,4}$/i)
  end

end
