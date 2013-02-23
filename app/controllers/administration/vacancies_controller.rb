class Administration::VacanciesController < Administration::ResourcesController
  before_filter :set_approved, :only => [:update, :create]

  def update
    if @resource.update_attributes(params[resource_name.downcase])
      flash[:message] = t(".#{resource_name.downcase}_updated_successfull")
      redirect_to :action => :awaiting_approve
    else
      render :edit
    end
  end

  def destroy
    if @resource.destroy
      flash[:message] = t(".#{resource_name.downcase}_deleted_successfull")
    end
    redirect_to :action => :awaiting_approve
  end

  def awaiting_approve
    @resources = Vacancy.awaiting_approve.page(params[:page])
    render :index
  end
  
  private

  def set_approved
    @resource.approved = params[:approved].present?
  end
end
