require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FitnesMan
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    config.i18n.default_locale = :ja

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.autoload_paths += %W[#{config.root}/app/services]

    # 日本語化
    config.i18n.default_locale = :ja
    config.time_zone = "Tokyo"

    # Database connection retry logic for CI environment
    if ENV["CI"].present?
      config.after_initialize do
        ActiveRecord::Base.connection_pool.disconnect!
        ActiveRecord::Base.establish_connection
      rescue ActiveRecord::NoDatabaseError, PG::ConnectionBad => e
        Rails.logger.warn "Database connection failed: #{e.message}"
        Rails.logger.warn "Retrying in 5 seconds..."
        sleep 5
        retry
      end
    end
  end
end
