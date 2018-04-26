ruby '2.4.3'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'rails', '~> 5.1.4'
gem 'pg'
gem 'activerecord-postgis-adapter'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'searchkick'
gem 'sidekiq'
gem 'haml'
gem 'simple_form'
gem 'nested_form'
gem 'bootstrap', '>= 4.1.0'
gem 'faker'
gem 'factory_bot'
gem 'kaminari'
gem 'rails-erd'
gem 'geocoder'
gem 'area'
gem 'devise'
gem 'paperclip', '~> 5.0.0'
gem 'mdb'
gem 'font-awesome-rails'
gem 'slim-rails'
gem 'concurrent-ruby'
gem 'redis-rails'
gem 'thread_safe'
gem 'google_drive'
gem 'retryable'
gem 'activesupport'
gem 'minitest'
gem 'rake'
gem 'retryable'
gem 'rgeo'
gem 'd3-rails'
gem 'ledermann-rails-settings'
gem 'rgb'
gem 'bootstrap4-kaminari-views'
# gem 'webpacker'

# used to create a temp cache to store items when doing things like fixtures.
gem 'moneta'

# gem 'jquery-datatables-rails', '~> 3.4.0'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development, :production_local, :test do
  gem 'pry'
end

group :development do
  gem 'listen'
  gem 'web-console', '>= 3.3.0'
  gem 'foreman'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
