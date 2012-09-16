class Administration::VacanciesController < Administration::ResourcesController
  before_filter :set_approved, :only => [:update, :create]
  
  private

  def set_approved
    @resource.approved = params[:approved].present?
  end
end