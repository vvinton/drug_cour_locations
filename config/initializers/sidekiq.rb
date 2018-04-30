# config/initializers/sidekiq.rb
require 'sidekiq'
puts "to sidekiq"

Sidekiq.configure_client do |config|
  config.redis = { size: 1, url: ENV['REDIS_PROVIDER'] }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 10, url: ENV['REDIS_PROVIDER'] }
end
