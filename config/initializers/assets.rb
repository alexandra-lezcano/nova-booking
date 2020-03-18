# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w( filterrific/filterrific-spinner.gif )
Rails.application.config.assets.precompile += %w( welcome.css )
Rails.application.config.assets.precompile += %w( welcome.js )
Rails.application.config.assets.precompile += %w( devise/sessions.css )
Rails.application.config.assets.precompile += %w( devise/sessions.js )
Rails.application.config.assets.precompile += %w( devise/passwords.css )
Rails.application.config.assets.precompile += %w( devise/passwords.js )
Rails.application.config.assets.precompile += %w( devise/registrations.css )
Rails.application.config.assets.precompile += %w( devise/registrations.js )
Rails.application.config.assets.precompile += %w( devise/confirmations.css )
Rails.application.config.assets.precompile += %w( devise/confirmations.js )
Rails.application.config.assets.precompile += %w( estates.css )
Rails.application.config.assets.precompile += %w( estates.js )
Rails.application.config.assets.precompile += %w( owners.css )
Rails.application.config.assets.precompile += %w( owners.js )
Rails.application.config.assets.precompile += %w( cities.css )
Rails.application.config.assets.precompile += %w( cities.js ) 
Rails.application.config.assets.precompile += %w( departaments.css )
Rails.application.config.assets.precompile += %w( departaments.js )
Rails.application.config.assets.precompile += %w( bookings.css )
Rails.application.config.assets.precompile += %w( bookings.js )