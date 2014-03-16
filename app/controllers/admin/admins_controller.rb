class Admin::AdminsController < Admin::ApplicationController
  before_action only: :destroy do
    if @resource.id == current_admin.id
      flash[:alert] = 'Cannot delete yourself!'
      respond_with @resource, location: after_destroy_path
    end
  end
  
  private

  def create_params(namespace)
    params.require(namespace).permit(:email, :password, :password_confirmation)
  end

  def update_params(namespace)
    create_params namespace
  end
end