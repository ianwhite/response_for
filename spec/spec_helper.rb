ENV["RAILS_ENV"] ||= "test"
require 'rails/all'
require 'rspec'
require 'rspec/rails'
require File.expand_path('../../lib/response_for', __FILE__)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
end

module ResponseForTest
  class Application < Rails::Application
    config.active_support.deprecation = :stderr
    paths['config/database'] = File.expand_path('../app/database.yml', __FILE__)
    paths['log'] = File.expand_path('../../../tmp/log', __FILE__)
  end
end

class ApplicationController < ActionController::Base
  self.view_paths = [File.expand_path('../app/views', __FILE__)]
end
  
ResponseForTest::Application.initialize!
Rails.application.routes.draw do
  match '*controller/:action'
end
