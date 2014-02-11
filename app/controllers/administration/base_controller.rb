class Administration::BaseController < ActionController::Base
  include Controllers::Secure
  include Controllers::Resourceable

  layout 'layouts/administration'

  before_action :authenticate_admin!
  before_action { I18n.locale = :en }

  respond_to :html

  def index
    @resources = resource_class.order('id desc').page(params[:page])
    respond_with @resources
  end

  def new
    respond_with @resource
  end

  def create
    if @resource.save
      flash[:notice] = "#{resource_class.name} created successfull!"
    end
    respond_with @resource, location: after_create_path
  end

  def edit
    respond_with @resource
  end

  def update
    if @resource.save
      flash[:notice] = "#{resource_class.name} updated successfull!"
    end
    respond_with @resource, location: after_update_path
  end

  def destroy
    if @resource.destroy
      flash[:notice] = "#{resource_class.name} removed successfull!"
    end
    respond_with @resource, location: after_destroy_path
  end

  protected

  def after_create_path
    url_for [:administration, controller_name]
  end

  def after_update_path
    after_create_path
  end

  def after_destroy_path
    after_create_path
  end
end