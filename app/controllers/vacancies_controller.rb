class VacanciesController < ApplicationController
  before_filter :load_vacancy, :only => [:show, :edit, :update]

  def index
    @finder = Finder.new(params)
    @vacancies = @finder.retrieve
  end

  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = Vacancy.new(params[:vacancy])
    if @vacancy.save
      flash[:notice] = t('.vacancy_created_successfull', :email => @vacancy.contact_email)
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    render_404 if !@vacancy.approved? && !current_admin
  end

  def edit
    render_404 if @vacancy.edit_token != params[:token] && !current_admin
  end

  def update
    if @vacancy.update_attributes(params[:vacancy])
      flash[:notice] = t('.vacancy_updated_successfull')
    end
    render :edit
  end

  def feed
    @finder = Finder.new
    @vacancies = @finder.retrieve
  end

  protected

  def load_vacancy
    @vacancy = Vacancy.find(params[:id])
  end
end
