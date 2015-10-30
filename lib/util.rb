module Util

  def self.config(key)
    return Honeybadger::App.settings.send(key)
  end

end
