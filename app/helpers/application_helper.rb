module ApplicationHelper
  def js_env
    templates = Hash[
      Rails.application.assets.each_file
           .select { |file| file.include?(Rails.root.to_s) && file.end_with?('html', 'json') }
           .map { |file| Rails.application.assets.find_asset(file).logical_path }
           .map { |file| [file, asset_path(file)] }
    ]

    data = {
      env: Rails.env,
      templates: templates,
      app_name: Rails.application.class.parent_name
    }

    <<-EOS.html_safe
      <script type="text/javascript">
        shared = angular.module('#{data[:app_name]}')
        shared.constant('Rails', #{data.to_json})
      </script>
    EOS
  end
end
