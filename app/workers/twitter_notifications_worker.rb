class TwitterNotificationsWorker
  @queue = :notifications
  
  def self.perform(id)
    return unless (v = Vacancy.find_by_id(id))
    twitter_client.update "[#{v.company_name}] #{v.title} #{Rails.application.routes.url_helpers.vacancy_url(v.id)} #appletunity"
  end

  protected

  def twitter_client
  	@twitter_client ||= Twitter::REST::Client.new(Settings.credentials.twitter)
  end
end