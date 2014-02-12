class VacancyMailer < ActionMailer::Base
  def created(vacancy)
    @vacancy = vacancy
    mail to: @vacancy.contact_email, subject: t('mailers.subjects.created')
  end

  def awaiting_approve(vacancy)
    @vacancy = vacancy
    mail to: Admin.all.map(&:email), subject: t('mailers.subjects.notify')
  end
end
