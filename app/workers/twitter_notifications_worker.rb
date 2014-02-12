class TwitterNotificationsWorker
  @queue = :notifications
  
  def self.perform(id)
    return unless (v = Vacancy.find_by_id(id))
    twitter_client.update "[#{v.company_name}] #{v.title} #{Rails.application.routes.url_helpers.vacancy_url(v, host: host)} #appletunity"
  end

  protected

  def self.twitter_client
    Twitter::REST::Client.new Settings.credentials.twitter.to_h
  end

  def self.host
  	ActionMailer::Base.default_url_options[:host]
  end
end