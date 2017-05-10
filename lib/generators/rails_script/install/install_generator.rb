module RailsScript
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../../../../app/assets/javascripts", __FILE__)

      def copy_files
        template 'base.coffee', 'app/assets/javascripts/base.coffee'
        template 'global.coffee', 'app/assets/javascripts/global.coffee'
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
