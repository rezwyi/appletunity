class VacancyMailer < ActionMailer::Base
  def created(vacancy)
    @vacancy = vacancy
    mail :to => vacancy.contact_email, :subject => t('.created_email')
  end
end
