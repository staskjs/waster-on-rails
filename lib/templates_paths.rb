module TemplatesPaths
  extend self

  def templates
    Hash[
      Rails.application.assets.each_file
           .select { |file| file.include?(Rails.root.to_s) && file.end_with?('swf', 'html', 'json') }
           .map { |file| Rails.application.assets.find_asset(file).logical_path }
           .map { |file| [file, ActionController::Base.helpers.asset_path(file)] }
    ]
  end
end
