require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Main
  class Application < Rails::Application
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }

    config.eager_load_paths += Dir["#{config.root}/lib/"]

    config.cache_store = :redis_store, 'redis://localhost:6379/0/cache', { expires_in: 90.minutes }

    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
    config.i18n.fallbacks = [:en]

    config.x.api_key = '2ec7fdfe37404f5e9a2324b1808273a8'
  end
end
