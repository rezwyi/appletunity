class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :check_captcha, :only => :create

  protected

  def render_404
    respond_to do |type|
      type.html do
        render :status => :not_found, :layout => false,
               :file => "#{Rails.root}/public/404.html"
      end
      type.all { render :status => :not_found, :nothing => true }
    end
  end

  def check_captcha
    redirect_to(root_url) and return if params[:captcha].present?
  end
end