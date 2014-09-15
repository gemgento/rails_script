module RailsScript
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_files
        template 'base.js.coffee', 'app/assets/javascripts/base.js.coffee'
        template 'global.js.coffee', 'app/assets/javascripts/global.js.coffee'
      end

      def create_directories
        directory 'utilities/', 'app/assets/javascripts/utilities'
        directory 'elements/', 'app/assets/javascripts/elements'
      end

      def insert_load_order
        if File.exist?('app/assets/javascripts/application.js')

          if File.readlines('app/assets/javascripts/application.js').grep('//= require_tree .').any?
            inject_into_file 'app/assets/javascripts/application.js',  "\n//= require base\n//= require_tree ./utilities\n//= require_tree ./elements", before: "\n//= require_tree ."
          else
            append_file 'app/assets/javascripts/application.js',  "\n//= require base\n//= require_tree ./utilities\n//= require_tree ./elements\n//= require_tree ."
          end

        elsif File.exist?('app/assets/javascripts/application.js.coffee')

          if File.readlines('app/assets/javascripts/application.js.coffee').grep('#= require_tree .').any?
            inject_into_file 'app/assets/javascripts/application.js.coffee', "\n#= require base\n#= require_tree ./utilities\n#= require_tree ./elements", before: "\n#= require_tree ."
          else
            append_file 'app/assets/javascripts/application.js.coffee',  "\n#= require base\n#= require_tree ./utilities\n#= require_tree ./elements\n#= require_tree ."
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