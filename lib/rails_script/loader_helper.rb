module RailsScript
  module LoaderHelper

    def include_rails_script
      content_tag :div, nil, id: 'rails-script', data: { controller: controller_path.split(/\/|_/).map(&:capitalize).join(''), vars: @to_javascript.to_json }
    end

  end
end
