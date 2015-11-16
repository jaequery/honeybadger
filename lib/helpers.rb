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
