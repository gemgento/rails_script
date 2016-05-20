module RailsScript
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../../../../app/assets/javascripts", __FILE__)

      def copy_files
        template 'base.coffee', 'app/assets/javascripts/base.coffee'
        template 'global.coffee', 'app/assets/javascripts/global.coffee'
      end

      def insert_load_order
        if File.exist?('app/assets/javascripts/application.js')

          if File.readlines('app/assets/javascripts/application.js').grep('//= require_tree .').any?
            inject_into_file 'app/assets/javascripts/application.js',  "//= require rails_script\n", before: '//= require_tree .'
          else
            append_file 'app/assets/javascripts/application.js',  "\n//= require rails_script"
          end

        elsif File.exist?('app/assets/javascripts/application.js.coffee')

          if File.readlines('app/assets/javascripts/application.js.coffee').grep('#= require_tree .').any?
            inject_into_file 'app/assets/javascripts/application.js.coffee', "#= require rails_script\n", before: '#= require_tree .'
          else
            append_file 'app/assets/javascripts/application.js.coffee',  "\n#= require rails_script"
          end
        end
      end

      def insert_layout_javascript
        say <<-RUBY
In order to complete installation, you must include the following helper BEFORE the closing body tag in the application layout:

<%= include_rails_script %>

        RUBY
      end

    end
  end
end