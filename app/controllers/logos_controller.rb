class LogosController < ApplicationController
  respond_to :json, only: :create

  rescue_from Logo::FingerprintError do |e|
    @resource = e.resource
    respond_with @resource
  end
  
  def create
    @resource.save
    respond_with @resource
  end

  private

  def create_params(namespace)
    params.require(namespace).permit(:image)
  end
end