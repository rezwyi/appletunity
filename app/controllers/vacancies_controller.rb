class VacanciesController < ApplicationController
  def index
    @finder = Appletunity::Finders::Base.new(params)
    @vacancies = @finder.retrieve
  end

  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = Vacancy.new(params[:vacancy])
    @vacancy.occupation_ids = params[:occupations]
    
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
end
