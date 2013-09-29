class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_captcha, :only => :create

  respond_to :html, :json

  protected

  def check_captcha
    redirect_to(root_url) and return if params[:captcha].present?
  end
end
