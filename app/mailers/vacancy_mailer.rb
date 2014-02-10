class VacancyMailer < ActionMailer::Base
  def created(vacancy)
    @vacancy = vacancy
    mail to: vacancy.contact_email, subject: t('.created_email')
  end

  def awaiting_approve(vacancy)
    @vacancy = vacancy
    mail to: Admin.all.map(&:email), subject: t('.notify_email')
  end
end
