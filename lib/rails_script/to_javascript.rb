module RailsScript
  module ToJavascript
    extend ActiveSupport::Concern

    included do
      before_action do
        @to_javascript = {}
      end
    end

    def to_javascript(variables = {})
      @to_javascript.merge!(variables)
    end

  end
end