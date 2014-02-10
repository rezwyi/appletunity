class Administration::VacanciesController < Administration::ResourcesController
  before_filter :set_approved, only: [:update, :create]

  set_redirect_action :awaiting_approve

  def awaiting_approve
    @resources = Vacancy.awaiting_approve.page(params[:page])
    render :index
  end
  
  protected

  def set_approved
    @resource.approved = params[:approved].present?
  end
end
