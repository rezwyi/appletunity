class TwitterNotificationsWorker
  include Rails.application.routes.url_helpers
  
  @queue = :notifications
  
  def self.perform(id)
    return unless (v = Vacancy.find_by_id(id))
    twitter_client.update "[#{v.company_name}] #{v.title} #{vacancy_url(v)} #appletunity"
  end

  protected

  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new(Settings.credentials.twitter)
  end
end