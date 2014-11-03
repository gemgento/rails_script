module RailsScript
  module LoaderHelper

    def include_rails_script
      javascript_tag <<-RUBY
window.Utility || (window.Utility = {});
Utility.RailsVars = #{@to_javascript.nil? ? '{}' : @to_javascript.to_json};

(function() {
  window.$this = new (App.#{ controller_path.split(/\/|_/).map(&:capitalize).join('') } || App.Base)();
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