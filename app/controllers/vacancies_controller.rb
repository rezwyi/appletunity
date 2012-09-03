class VacanciesController < ApplicationController
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
end
