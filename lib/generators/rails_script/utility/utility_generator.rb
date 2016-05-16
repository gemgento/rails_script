module RailsScript
  module Generators
    class UtilityGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :utility_name, type: :string

      def generate_file
        template 'javascript.js.coffee', "app/assets/javascripts/utilities/#{utility_name.underscore}.js.coffee"
      end

    end
  end
end