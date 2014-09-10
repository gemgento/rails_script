module RailsScript
  module LoaderHelper

    def include_rails_script
      javascript_tag <<-RUBY
  jQuery(function() {
    window.$this = new (App.#{ controller_path.split(/\/|_/).map(&:capitalize).join('') } || App.Base)();
    if (typeof $this.#{ action_name } === 'function') {
      return $this.#{ action_name }.call();
    }
  });
      RUBY
    end

  end
end