class Administration::AdminsController < Administration::BaseController
  private

  def create_params(namespace)
    params.require(namespace).permit(:email, :password, :password_confirmation)
  end

  def update_params(namespace)
    create_params namespace
  end
end