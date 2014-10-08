window.Utility || (window.Utility = {});
Utility.RailsVars = #{@to_javascript.nil? ? '{}' : @to_javascript.to_json};

function() {
  window.$this = new (App.#{ controller_path.split(/\/|_/).map(&:capitalize).join('') } || App.Base)();
  if (typeof $this.#{ action_name } === 'function') {
    return $this.#{ action_name }.call();
  }
};