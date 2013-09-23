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
    if @vacancy.save
      flash[:notice] = t('.vacancy_created_successfull', :email => @vacancy.contact_email)
    end
    respond_with @vacancy, :location => root_url
  end

  def show
    unless @vacancy.approved? || admin_signed_in?
      raise ActionController::RoutingError, 'Not found'
    end
    respond_with @vacancy
  end

  def edit
    unless @vacancy.edit_token == params[:token] || admin_signed_in?
      raise ActionController::RoutingError, 'Not found'
    end
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
