module RailsScript
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_files
        template 'rails_script/base.js.coffee', 'app/assets/javascripts/base.js.coffee'
        template 'rails_script/global.js.coffee', 'app/assets/javascripts/global.js.coffee'
      end

      def insert_load_order
        if File.exist?('app/assets/javascripts/application.js')
          inject_into_file 'app/assets/javascripts/application.js',  "\n//= require base", before: "\n//= require_tree ."
        elsif File.exist?('app/assets/javascripts/application.js.coffee')
          inject_into_file 'app/assets/javascripts/application.js.coffee', "\n#= require base", before: "\n#= require_tree ."
        end
      end

    end
  end
end