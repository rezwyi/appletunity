class Admin::ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'admin/layouts/configuration'
end
