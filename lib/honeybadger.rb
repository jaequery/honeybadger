# mailjet, usage:
# 
# make sure either :template or :text and :html are passed. if none of them are passed, it defaults
# to :template with the default template id from config/apps.rb
# 
# - template way
# mailjet({
#   :from => 'support@site.com', #(optional, defaults in config/apps.rb)
#   :to => 'some@body.com',
#   :bcc => ['test@test.com'], #(optional)
#   :subject => 'test message',
#   :template => {:id => 123, :name => 'jae lee', :message => 'this is a test message'}, #(optional if text or html is set)
# })
# 
# - standard way
# mailjet({
#   :from => 'support@site.com', #(optional, defaults in config/apps.rb)
#   :to => 'some@body.com',
#   :bcc => ['test@test.com'], #(optional)
#   :subject => 'test message',
#   :text => "this is a text message", 
#   :html => "this is an html message",
# })
def mailjet(opts)

  # configure keys
  Mailjet.configure do |config|
    config.api_key = setting('mailjet')[:api_key]
    config.secret_key = setting('mailjet')[:secret_key]
  end

  # set recipients
  to = opts[:to]

  # copy markett employees
  bcc = []
  if Padrino.env == "production"
    setting('bcc').each do |email|
      bcc << email
    end
  end

  # set data to pass to mailjet
  data = {
    :from_email => opts[:from] || setting('mailjet')[:from],
    :from_name => opts[:from] || setting('mailjet')[:from],
    :subject => opts[:subject],
    :"Mj-TemplateID" => opts[:template][:id] || setting('mailjet')[:template_id],
    :"Mj-TemplateLanguage" => "true",
    :to => to,
    :bcc => bcc.join(","),
  }

  # choose either direct or template
  if !opts[:template].nil?
    data[:vars] = opts[:template]
  end

  if !opts[:text].nil?
    data[:text_part] = opts[:text]
  end

  if !opts[:html].nil?
    data[:html_part] = opts[:html]
  end

  # send mail
  res = Mailjet::Send.create(data)

  return res
  
end


def number_to_currency(number, options = {})
  options.symbolize_keys!

  defaults  = I18n.translate(:'number.format', :locale => options[:locale], :raise => true) rescue {}
  currency  = I18n.translate(:'number.currency.format', :locale => options[:locale], :raise => true) rescue {}
  defaults  = defaults.merge(currency)

  precision = options[:precision] || defaults[:precision]
  unit      = options[:unit]      || defaults[:unit]
  separator = options[:separator] || defaults[:separator]
  delimiter = options[:delimiter] || defaults[:delimiter]
  format    = options[:format]    || defaults[:format]
  separator = '' if precision == 0

  begin
    format.gsub(/%n/, number_with_precision(number,
      :precision => precision,
      :delimiter => delimiter,
      :separator => separator)
    ).gsub(/%u/, unit)
  rescue
    number
  end
end


def print_r(inHash, *indent)
    @indent = indent.join
    if (inHash.class.to_s == "Hash") then
        print "Hash\n#{@indent}(\n"
        inHash.each { |key, value|
            if (value.class.to_s =~ /Hash/) || (value.class.to_s =~ /Array/) then
                print "#{@indent}    [#{key}] => "
                self.print_r(value, "#{@indent}        ")
            else
                puts "#{@indent}    [#{key}] => #{value}"
            end
        }
        puts "#{@indent})\n"
    elsif (inHash.class.to_s == "Array") then
        print "Array\n#{@indent}(\n"
        inHash.each_with_index { |value,index|
            if (value.class.to_s == "Hash") || (value.class.to_s == "Array") then
                print "#{@indent}    [#{index}] => "
                self.print_r(value, "#{@indent}        ")
            else
                puts "#{@indent}    [#{index}] => #{value}"
            end
        }
        puts "#{@indent})\n"
    end
    #   Pop last indent off
    puts 8.times {@indent.chop!}
end

def output(content)
  content
end