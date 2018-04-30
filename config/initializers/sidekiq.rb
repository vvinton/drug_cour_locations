# config/initializers/sidekiq.rb
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { size: 1, url: ENV['REDIS_PROVIDER'] }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 30, url: ENV['REDIS_PROVIDER'] }
end
