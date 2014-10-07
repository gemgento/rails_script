module RailsScript
  module LoaderHelper

    def include_rails_script
      javascript_tag <<-RUBY
      window.Utility || (window.Utility = {});Utility.RailsVars = #{@to_javascript.nil? ? '{}' : @to_javascript.to_json};jQuery(function(){window.$this=new(App.#{controller_path.split(/\/|_/).map(&:capitalize).join('')}||App.Base);if(typeof $this.#{action_name}==="function"){return $this.#{action_name}.call()}});jQuery(document).on("page:before-change",function(){var e,t,n,r,i,s,o,u;o=[window,document];u=[];for(i=0,s=o.length;i<s;i++){e=o[i];u.push(function(){var i,s;i=jQuery._data(e,"events");s=[];for(r in i){n=i[r];s.push(function(){var i,s,o;o=[];for(i=0,s=n.length;i<s;i++){t=n[i];if(t==null){continue}o.push(t.namespace===""?$(e).off(r,t.handler):void 0)}return o}())}return s}())}return u})
      RUBY
    end

  end
end