require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Load the .env environment so we can maintain things more easily
Dotenv::Railtie.load

module DrugCourtLocation
  class Application < Rails::Application
    config.active_job.queue_adapter = :sucker_punch
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
