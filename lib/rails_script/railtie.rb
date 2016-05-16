module RailsScript
  class Railtie < Rails::Railtie
    config.app_generators do |g|
      g.templates.unshift File::expand_path('../../templates', __FILE__)
    end

    initializer 'rails_Script.loader_helper' do
      ActionView::Base.send :include, LoaderHelper
    end

    initializer 'rails_script.to_javascript' do
      ActionController::Base.send :include, ToJavascript
    end
    
  end
end