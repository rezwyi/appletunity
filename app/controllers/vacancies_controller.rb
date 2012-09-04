class VacanciesController < ApplicationController
  after_filter :send_created_email, :only => :create

  def index
    @finder = Appletunity::Finders::Base.new(params)
    @vacancies = @finder.retrieve
  end

  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = Vacancy.create(params[:vacancy])
    
    if @vacancy.save
      flash[:message] = t('.vacancy_created_successfull')
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    @vacancy = Vacancy.find(params[:id])
  end

  def edit
    @vacancy = Vacancy.find(params[:id])
    render_404 and return unless @vacancy.edit_token == params[:token]
  end

  def update
    @vacancy = Vacancy.find(params[:id])
    
    if @vacancy.update_attributes(params[:vacancy])
      flash[:message] = t('.vacancy_updated_successfull')
      redirect_to :action => :show
    else
      render 'edit'
    end
  end

  private

  def send_created_email
    return unless @vacancy
    VacancyMailer.delay(:queue => 'mailing').created(@vacancy)
  end
end
