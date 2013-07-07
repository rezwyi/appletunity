class Administration::ResourcesController < ActionController::Base
  protect_from_forgery

  layout 'layouts/administration'

  before_filter :authenticate_admin!
  before_filter :load_resource, :only => [:edit, :update, :destroy]
  before_filter :create_resource, :only => :create

  class << self
    @@redirect_action = :index

    def set_redirect_action(action)
      @@redirect_action = action
    end
  end

  def index
    params[:per_page] ||= Rails.application.config.default_per_page
    @resources = resource_class.order('id DESC').page(params[:page]).per(params[:per_page])
  end

  def new
    @resource = resource_name.constantize.new
  end

  def create
    if @resource.save
      flash[:notice] = t(".#{resource_name.downcase}_created_successfull", :email => nil)
      redirect_to :action => @@redirect_action
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @resource.update_attributes(params[resource_name.downcase])
      flash[:notice] = t(".#{resource_name.downcase}_updated_successfull")
      redirect_to :action => @@redirect_action
    else
      render :edit
    end
  end

  def destroy
    if @resource.destroy
      flash[:notice] = t(".#{resource_name.downcase}_deleted_successfull")
    end
    redirect_to :action => @@redirect_action
  end

  protected

  def resource_name
    controller_name.classify
  end

  def resource_class
    resource_name.constantize
  end

  def load_resource
    @resource = resource_name.constantize.find(params[:id])
  end

  def create_resource
    @resource = resource_name.constantize.create(params[resource_name.downcase])
  end
end
