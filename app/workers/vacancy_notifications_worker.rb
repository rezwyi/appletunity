class VacancyNotificationsWorker
	@queue = :notifications
  
  def self.perform(id)
    return unless (v = Vacancy.find_by_id(id))
    VacancyMailer.created(v).deliver
    VacancyMailer.awaiting_approve(v).deliver unless v.approved?
  end
end