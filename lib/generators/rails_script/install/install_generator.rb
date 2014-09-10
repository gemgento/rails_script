module RailsScript
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_files
        template 'base.js.coffee', 'app/assets/javascripts/base.js.coffee'
        template 'global.js.coffee', 'app/assets/javascripts/global.js.coffee'
      end

      def insert_load_order
        if File.exist?('app/assets/javascripts/application.js')
          inject_into_file 'app/assets/javascripts/application.js',  "\n//= require base", before: "\n//= require_tree ."
        elsif File.exist?('app/assets/javascripts/application.js.coffee')
          inject_into_file 'app/assets/javascripts/application.js.coffee', "\n#= require base", before: "\n#= require_tree ."
        end
      end

      def create_controllers
        generate 'rails_script:controller'
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