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

  jQuery(document).on('page:before-change', function() {
    jQuery(document).off();
    jQuery(window).off();
  });
      RUBY
    end

  end
end