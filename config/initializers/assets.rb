# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join('config', 'locales')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += ['*.html', '*.json']

# register .json for assets pipeline
Sprockets.register_mime_type 'application/json', extensions: ['.json']

# enable to use sprockets directive processor in .json
Sprockets.register_preprocessor 'application/json', Sprockets::ERBProcessor
Sprockets.register_preprocessor 'application/json', Sprockets::DirectiveProcessor
