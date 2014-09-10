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
In order to complete installation, you must add the following JavaScript snippet before the CLOSING body tag in your application layout.

ERB:
<script>
  jQuery(function() {
    window.$this = new (App.<%= controller_path.split(/\/|_/).map(&:capitalize).join('') %> || App.Base)();
    if (typeof $this.<%= action_name %> === 'function') {
      return $this.<%= action_name%>.call();
    }
  });
</script>

HAML:
:javascript
  jQuery(function() {
    window.$this = new (App.\#{controller_path.split(/\/|_/).map(&:capitalize).join('')} || App.Base)();
    if (typeof $this.\#{action_name} === 'function') {
      return $this.\#{action_name}.call();
    }
  });
        RUBY
      end

    end
  end
end