class ApplicationController < ActionController::Base
  include Controllers::Secure
  include Controllers::Resourceable

  before_action { I18n.locale = :ru }
  before_action :check_captcha, only: :create

  def new
    respond_with @resource
  end

  def show
    respond_with @resource
  end

  def edit
    respond_with @resource
  end

  protected

  def check_captcha
    redirect_to(root_path) if params[:captcha].present?
  end

  def pjax_layout
    'pjax'
  end
end