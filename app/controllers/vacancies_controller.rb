class VacanciesController < ApplicationController
  include Controllers::Logoable
  
  before_action only: :show do
    unless @resource.approved? || admin_signed_in?
      raise ActionController::RoutingError, 'Not found'
    end
  end
  
  before_action only: %i(edit update) do
    unless @resource.edit_token == params[:token] || admin_signed_in?
      raise ActionController::RoutingError, 'Not found'
    end
  end

  respond_to :html, except: :feed
  respond_to :json, only: %i(create update)
  respond_to :rss, only: :feed

  def index
    @vacancies = Finder.new(params).retrieve
    respond_with @vacancies
  end

  def create
    if @resource.save
      flash[:notice] = t('messages.vacancy_created_successfull', email: @resource.contact_email)
    end
    respond_with @resource, location: root_path
  end

  def update
    if @resource.save
      flash[:notice] = t('messages.vacancy_updated_successfull')
    end
    respond_with @resource, location: @resource.approved? ? vacancy_path(@resource) : root_path
  end

  def feed
    @vacancies = Finder.new(params).retrieve
    respond_with @vacancies
  end

  private

  def create_params(namespace)
    params.require(namespace).permit(
      :company_name, :company_website, :title, :body, :location, :contact_email, :contact_phone, :agreed_to_offer,
      occupationables_attributes: [:id, :occupation_id, :_destroy]
    )
  end

  def update_params(namespace)
    params.require(namespace).permit(
      :company_name, :company_website, :body, :location, :contact_email,:contact_phone,
      occupationables_attributes: [:id, :occupation_id, :_destroy]
    )
  end
end