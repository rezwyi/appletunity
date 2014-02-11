class Administration::VacanciesController < Administration::BaseController
  before_action :set_approved, only: [:update, :create]

  def index
    @resources = Finder.new(params).retrieve
    respond_with @resources
  end
  
  protected

  def set_approved
    @resource.approved = params[:approved].present?
  end

  def after_create_path
    @resource.approved? ? super : administration_vacancies_path(awaiting_approve: '1')
  end

  def after_update_path
    after_create_path
  end

  private

  def create_params(namespace)
    params.require(namespace).permit(
      :company_name, :company_website, :title, :body, :location, :contact_email, :contact_phone,
      :agreed_to_offer, :logo, vacancies_occupations_attributes: [:id, :occupation_id, :_destroy]
    )
  end

  def update_params(namespace)
    create_params namespace
  end
end