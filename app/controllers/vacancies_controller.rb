class VacanciesController < ApplicationController
  before_filter :load_vacancy, :only => [:show, :edit, :update]

  respond_to :rss, :only => :feed

  def index
    @finder = Finder.new(params)
    @vacancies = @finder.retrieve
    respond_with @vacancies
  end

  def new
    @vacancy = Vacancy.new
    respond_with @vacancy
  end

  def create
    @vacancy = Vacancy.new(params[:vacancy])
    if (saved = @vacancy.save)
      flash[:notice] = t('.vacancy_created_successfull', :email => @vacancy.contact_email)
    end
    respond_with @vacancy, :location => (saved ? root_url : nil)
  end

  def show
    render_404 if !@vacancy.approved? && !current_admin
    respond_with @vacancy
  end

  def edit
    render_404 if @vacancy.edit_token != params[:token] && !current_admin
    respond_with @vacancy
  end

  def update
    if (updated = @vacancy.update_attributes(params[:vacancy]))
      flash[:notice] = t('.vacancy_updated_successfull')
    end
    respond_with @vacancy
  end

  def feed
    @finder = Finder.new
    @vacancies = @finder.retrieve
    respond_with @vacancies
  end

  protected

  def load_vacancy
    @vacancy = Vacancy.find(params[:id])
  end
end
