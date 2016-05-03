# Helper methods defined here can be accessed in any controller or view in the application

module Honeybadger
  class SiteApp
    module SiteHelper

        class CodeRayify < Redcarpet::Render::HTML
          def block_code(code, language)
            CodeRay.scan(code, language).div
          end
        end

        def paginate(model)
          will_paginate @posts, renderer: BootstrapPagination::Sinatra, :previous_label => '&laquo;', :next_label => '&raquo;'
        end

        def markdown(text)
          coderayified = CodeRayify.new(:filter_html => true, 
                                        :hard_wrap => true)
          options = {
            :fenced_code_blocks => true,
            :no_intra_emphasis => true,
            :autolink => true,
            :lax_html_blocks => true,
          }
          markdown_to_html = Redcarpet::Markdown.new(coderayified, options)
          markdown_to_html.render(text).html_safe
        end

    end

    helpers SiteHelper
  end


  

  


end
