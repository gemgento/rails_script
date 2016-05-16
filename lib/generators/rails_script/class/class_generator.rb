module RailsScript
  module Generators
    class ClassGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :class_name, type: :string

      def generate_file
        template 'javascript.js.coffee', "app/assets/javascripts/#{class_name.underscore}.js.coffee"
      end

    end
  end
end