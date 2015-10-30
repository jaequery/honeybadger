module Util

  def self.config(key)
    return Honeybadger::App.settings.send(key)
  end

  def self.valid_json?(json)
    JSON.parse(json)
    true
  rescue
    false
  end

end
