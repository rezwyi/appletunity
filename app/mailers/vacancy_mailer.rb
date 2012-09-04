class VacancyMailer < ActionMailer::Base
  def created(vacancy)
    @vacancy = vacancy
    mail :to => vacancy.contact_email, :subject => t('.vacancy_creation')
  end
end
