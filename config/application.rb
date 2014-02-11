require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env)

module Appletunity
  class Application < Rails::Application
    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Moscow'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.locale = :ru
    config.i18n.default_locale = :ru
    I18n.enforce_available_locales = false

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end
