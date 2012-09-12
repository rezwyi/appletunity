class Informator < ActiveRecord::Observer
  include Rails.application.routes.url_helpers
  
  observe :vacancy

  def after_create(vacancy)
    Twitter.delay(:queue => 'tweeting').update status(vacancy)
  end

  private

  def status(vacancy)
    "[#{vacancy.company_name}] #{vacancy_url(vacancy)} #appletunity"
  end
end