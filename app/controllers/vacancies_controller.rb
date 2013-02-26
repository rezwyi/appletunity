class VacanciesController < ApplicationController
  before_filter :load_vacancy, :only => [:show, :edit, :update]
  after_filter :send_created_email, :only => :create

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
      flash[:message] = t('.vacancy_created_successfull',
                          :email => @vacancy.contact_email)
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show
    render_404 and return unless @vacancy.approved?
  end

  def edit
    render_404 and return unless @vacancy.edit_token == params[:token]
  end

  def update
    if @vacancy.update_attributes(params[:vacancy])
      flash[:message] = t('.vacancy_updated_successfull')
      redirect_to :action => :show
    else
      render 'edit'
    end
  end

  def feed
    @finder = Finder.new
    @vacancies = @finder.retrieve
  end

  private

  def load_vacancy
    @vacancy = Vacancy.find(params[:id])
  end

  def send_created_email
    return unless @vacancy
    VacancyMailer.delay(:queue => 'mailing').created(@vacancy)
  end
end
