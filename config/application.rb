require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module FlashcardsApp
  class Application < Rails::Application
    config.load_defaults 5.2

    config.paths.add 'command/lib', eager_load: true
    config.paths.add 'content/lib', eager_load: true
  end
end
