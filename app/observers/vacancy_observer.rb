class VacancyObserver < ActiveRecord::Observer
  def after_create(vacancy)
    Resque.enqueue VacancyNotificationsWorker, vacancy.id
  end

  def after_save(vacancy)
  	if vacancy.expired_at && vacancy.expired_at_changed?
      Resque.enqueue TwitterNotificationsWorker, vacancy.id
    end
  end
end