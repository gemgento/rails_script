module RailsScript
  module Generators
    class ElementGenerator < ::Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
      argument :element_name, type: :string
      argument :utility, type: :string, default: ''

      def generate_file
        template 'javascript.js.coffee', "app/assets/javascripts/elements/#{element_name.underscore}.js.coffee"
      end

    end
  end
end