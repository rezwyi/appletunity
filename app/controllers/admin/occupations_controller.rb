class Admin::OccupationsController < Admin::ApplicationController
  private

  def create_params(namespace)
    params.require(namespace).permit(:name)
  end

  def update_params(namespace)
    create_params namespace
  end
end