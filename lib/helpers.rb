def config(name, value = nil)

  # return config value
  if value.nil?

    # do lookup
    row = Setting.where(:name => name).first[:value]

    # if not found, get settings from config/apps.rb
    if row.nil?
      row = settings.send(name).dup rescue nil
    end

    if row[0] == '{'
      row = eval(row)
    end

  elsif

    if value == ""
      Setting.where(:name => name).destroy
    end

  else
    row = Setting.where(:name => name)

    if value.class == Hash
      value = value.to_s
    end

    if row.count == 0
      Setting.new(:name => name, :value => value).save
    else
      row.update(:name => name, :value => value)
    end
  end

  return row
end

def print_r(inHash, *indent)
  @indent = indent.join

  if (inHash.class.to_s == "Hash") then
    print "Hash\n#{@indent}(\n"
    inHash.each { |key, value|
      #print "#{value.class.to_s}"
      if (value.class.to_s =~ /JSONBHash/) || (value.class.to_s =~ /JSONBArray/) then
        puts "#{@indent}    [#{key}] => #{value}"

      elsif (value.class.to_s =~ /Hash/) || (value.class.to_s =~ /Array/) then
        print "#{@indent}    [#{key}] => "
        self.print_r(value, "#{@indent}        ")
      else
        puts "#{@indent}    [#{key}] => #{value}"
      end
    }
    puts "#{@indent})"
  elsif (inHash.class.to_s == "Array") then
    print "Array\n#{@indent}(\n"
    inHash.each_with_index { |value,index|
      if (value.class.to_s =~ /JSONBHash/) || (value.class.to_s =~ /JSONBArray/) then
        puts "#{@indent}    [#{key}] => #{value}"
      elsif (value.class.to_s == "Hash") || (value.class.to_s == "Array") then
        print "#{@indent}    [#{index}] => "
        self.print_r(value, "#{@indent}        ")
      else
        puts "#{@indent}    [#{index}] => #{value}"
      end
    }
    puts "#{@indent})"
  end
  #   Pop last indent off
  puts 8.times {@indent.chop!}
end
