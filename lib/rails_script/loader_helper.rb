module RailsScript
  module LoaderHelper

    def include_rails_script
      javascript_tag <<-RUBY
window.Utility || (window.Utility = {});
Utility.RailsVars = #{@to_javascript.nil? ? '{}' : @to_javascript.to_json};

(function() {
  window.$this = new (App.#{ controller_path.split(/\/|_/).map(&:capitalize).join('') } || App.Base)();
  if (typeof $this.all === 'function') {
    $this.all.call();
  }
  if (typeof $this.#{ action_name } === 'function') {
    $this.#{ action_name }.call();
  }
})();
RUBY
    end

  end
end