module RailsScript
  module Generators
    class ControllerGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :controller, type: :string

      def generate_file
        template 'javascript.js.coffee', "app/assets/javascripts/#{controller.underscore}.js.coffee"
      end

    end
  end
end