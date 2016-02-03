require 'rails_script/version'
require 'rails_script/loader_helper'
require 'rails_script/to_javascript'
require 'rails_script/railtie' if defined?(Rails)

module RailsScript
  mattr_accessor :app_namespace
  @@app_namespace = 'App'
  
  def self.config
    yield self
  end
end
