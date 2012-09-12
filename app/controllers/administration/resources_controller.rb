class Administration::ResourcesController < ActionController::Base
  protect_from_forgery
  layout 'administration/layouts/application'

  before_filter :authenticate_admin!
  before_filter :load_resource, :only => [:edit, :update, :destroy]
  before_filter :create_resource, :only => :create

  def index
    params[:per_page] ||= Rails.application.config.default_per_page
    @resources = resource_name.constantize.order('id DESC')\
                              .page(params[:page]).per(params[:per_page])
  end

  def new
    @resource = resource_name.constantize.new
  end

  def create
    if @resource.save
      flash[:message] = t(".#{resource_name.downcase}_created_successfull")
      redirect_to :action => :index
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @resource.update_attributes(params[resource_name.downcase])
      flash[:message] = t(".#{resource_name.downcase}_updated_successfull")
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

  def destroy
    if @resource.destroy
      flash[:message] = t(".#{resource_name.downcase}_deleted_successfull")
    end

    redirect_to :action => :index
  end

  protected

  # Classify current controller name
  def resource_name
    controller_name.classify
  end

  def load_resource
    @resource = resource_name.constantize.find(params[:id])
  end

  def create_resource
    @resource = resource_name.constantize.create(params[resource_name.downcase])
  end
end