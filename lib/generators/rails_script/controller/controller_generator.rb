module RailsScript
  module Generators
    class ControllerGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :controller_name, type: :string, default: ''
      hook_for :controller

      def generate_file
        if controller_name.blank?
          Rails.application.eager_load!
          controllers = ApplicationController.descendants.map(&:to_s)
          controllers.each{ |c| c.gsub!('Controller', '') }
        else
          controllers = [controller_name]
        end

        controllers.each do |controller|
          copy_file 'javascript.js.coffee', "app/assets/javascripts/#{controller.underscore}.js.coffee"
          gsub_file "app/assets/javascripts/#{controller.underscore}.js.coffee", 'Example', controller.gsub('::', '')
        end
      end

    end
  end
end