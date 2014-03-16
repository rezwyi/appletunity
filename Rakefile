#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Appletunity::Application.load_tasks

# The :factory_specs task will need to run and succeed before the whole suite is run.
# See more http://robots.thoughtbot.com/testing-your-factories-first
if defined?(RSpec)
  desc 'Run factory specs'
  RSpec::Core::RakeTask.new(:factory_specs) do |t|
    t.pattern = './spec/factories_spec.rb'
  end
end

task spec: :factory_specs