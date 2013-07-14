class TwitterNotificationsWorker
  @queue = :notifications
  
  def self.perform(id)
    return unless (v = Vacancy.find_by_id(id))
    Twitter.update "[#{v.company_name}] #{v.title} #{Rails.application.routes.url_helpers.vacancy_url(v.id)} #appletunity"
  end
end