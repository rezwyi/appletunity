class ApplicationController < ActionController::Base
  protect_from_forgery

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
end
