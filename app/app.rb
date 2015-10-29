module Honeybadger
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get "/" do
      "Hello World!"
    end

  end
end
