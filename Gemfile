source 'https://rubygems.org'

gem 'rails', '~> 4.1.0'

gem 'unicorn-rails'
gem 'mysql2'

gem 'therubyracer'
gem 'jquery-rails', '~> 2.1.4'
gem 'jquery-ui-rails'
gem 'pjax_rails'
gem 'js-routes'

gem 'slim-rails'
gem 'coffee-rails'
gem 'compass-rails'
gem 'jbuilder'
gem 'sass-rails'
gem 'bootstrap-sass', '~> 2.3.0.0'

gem 'rails_config'
gem 'kaminari'
gem 'russian'
gem 'paperclip'
gem 'exception_notification'
gem 'twitter'
gem 'whenever', require: false
gem 'resque', '~> 1.24.1'
gem 'devise', '~> 3.0.0'

group :assets do
  gem 'uglifier'
end

group :development do
  gem 'quiet_assets'
  gem 'mailcatcher'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-resque', github: 'sshingler/capistrano-resque', require: false
  gem 'rconsole'
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'webmock'
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'rspec-rails', '~> 2.14.0'
  gem 'capybara'
  gem 'konacha'
end