module RailsScript
  module LoaderHelper

    def include_rails_script
      javascript_tag <<-RUBY
window.Utility || (window.Utility = {});
Utility.RailsVars = #{@to_javascript.nil? ? '{}' : @to_javascript.to_json};

(function() {
  window.$this = new (#{RailsScript.app_namespace}.#{ controller_path.split(/\/|_/).map(&:capitalize).join('') } || #{RailsScript.app_namespace}.Base)();
  if (typeof $this.beforeAction === 'function') {
    $this.beforeAction("#{action_name}");
  }
  if (typeof $this.#{ action_name } === 'function') {
    $this.#{ action_name }();
  }
  if (typeof $this.afterAction === 'function') {
    $this.afterAction("#{action_name}");
  }
})();
      RUBY
    end

  end
end
