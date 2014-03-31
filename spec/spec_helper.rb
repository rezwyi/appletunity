ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'shoulda-matchers'
require 'paperclip/matchers'
require 'capybara/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = ::Rails.root.join('spec', 'fixtures')
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  # Devise
  config.include Devise::TestHelpers, type: :controller

  # Paperclip matchers
  config.include Paperclip::Shoulda::Matchers
end