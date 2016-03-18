# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class SiteApp
    module SiteHelper

      def paginate(model)
        will_paginate @posts, renderer: BootstrapPagination::Sinatra, :previous_label => '&laquo;', :next_label => '&raquo;'
      end

    end

    helpers SiteHelper
  end
end
