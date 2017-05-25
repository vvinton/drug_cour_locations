ruby '2.3.3'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'
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
gem 'haml'
gem 'simple_form'
gem 'nested_form'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'faker'
gem 'factory_girl'
gem 'kaminari'
gem 'rails-erd'
gem 'geocoder'
gem 'area'
gem 'devise'
gem "paperclip", "~> 5.0.0"
gem 'mdb'
gem 'font-awesome-rails'
gem 'sucker_punch'
gem 'slim-rails'
gem 'pry'

gem 'jquery-datatables-rails', '~> 3.4.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'sqlite3'
  gem 'pry'
end

group :development do
  gem 'pry-byebug'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
