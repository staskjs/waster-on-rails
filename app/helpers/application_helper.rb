module ApplicationHelper
  def js_env
    if Rails.env.production?
      assets = Hash[
        Rails.application.assets_manifest.files
          .select do |file|
            file.end_with?('html', 'html.erb', 'json', 'json.erb')
          end
          .map { |_file, info| info['logical_path'] }
          .map { |file| [file, asset_path(file)] }
      ]
    else
      assets = Hash[
        Rails.application.assets.each_file
          .select do |file|
            file.include?(Rails.root.to_s) && file.end_with?('html', 'html.erb', 'json', 'json.erb')
          end
          .map { |file| Rails.application.assets.find_asset(file).logical_path }
          .map { |file| [file, asset_path(file)] }
      ]
    end

    data = {
      env: Rails.env,
      assets: assets,
      app_name: Rails.application.class.parent_name,
      locale: I18n.locale
    }

    <<-EOS.html_safe
      <script type="text/javascript">
        shared = angular.module('#{data[:app_name]}')
        shared.constant('Rails', #{data.to_json})
      </script>
    EOS
  end
end
