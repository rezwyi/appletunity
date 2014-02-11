class VacancyMailer < ActionMailer::Base
  def created(vacancy)
    @vacancy = vacancy
    mail to: @vacancy.contact_email, subject: t('ui.mailers.text.created_email')
  end

  def awaiting_approve(vacancy)
    @vacancy = vacancy
    mail to: Admin.all.map(&:email), subject: t('ui.mailers.text.notify_email')
  end
end
