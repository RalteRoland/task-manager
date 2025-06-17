require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module TaskManager
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = false

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore,
      key: '_task_manager_session',
      domain: 'localhost'  # This allows cookies to work across ports

    config.autoload_lib(ignore: %w[assets tasks])
  end
end
