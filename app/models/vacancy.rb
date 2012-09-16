class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations, :dependent => :destroy
  has_many :occupations, :through => :vacancies_occupations

  validates :title, :body, :company_name, :contact_email, :agreed_to_offer,
            :presence => true

  validates :edit_token, :uniqueness => true

  validates :title, :length => {:maximum => 70}
  validates :company_name, :length => {:maximum => 30}

  validates :contact_email, :format => {:with => Devise.email_regexp}

  validates_attachment :logo, :size => {:in => 0..100.kilobytes}

  attr_accessible :company_name, :company_website, :title, :body, :location,
                  :occupation_ids, :contact_email, :contact_phone,
                  :agreed_to_offer, :logo

  before_create :generate_edit_token
  before_save :render_body
  before_save :generate_expired_at

  has_attached_file :logo,
                    :styles => {:small => '80x80', :medium => '100x100'}

  scope :live, lambda {
    where('approved = ? AND expired_at >= ?', true, Time.now)
  }

  scope :not_approved, lambda {
    where('approved = ? AND expired_at IS NULL', false)
  }

  # Simple random token generator
  def self.friendly_token
    SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
  end

  # Used from whenever task
  def self.tweet_about_new_vacancies
    now = Time.now
    Vacancy.live.where(:created_at => (now - 1.hour)..now).each do |v|
      url = Rails.application.routes.url_helpers.vacancy_url(v)
      status = "[#{v.company_name}] #{v.title} #{url} #appletunity"
      Twitter.delay(:queue => 'tweeting').update(status)
    end
  end

  # Used from whenever task
  def self.notify_about_not_approved_vacancies
    if (vs = Vacancy.not_approved)
      VacancyMailer.delay(:queue => 'mailing').not_approved(vs.to_a)
    end
  end

  def to_param
    "#{self.id.to_s}-#{self.ascii_title}"
  end

  def approved?
    !!self.approved
  end

  def expired?
    self.expired_at && self.expired_at <= Time.now
  end

  protected

  def ascii_title
    title = self.title.split(' ').map do |w|
      Russian::translit(w).downcase.gsub(/\W/,'-').strip
    end
    title.join('-').gsub(/[-]+/, '-').gsub(/^-/, '').gsub(/-$/, '')
  end

  def generate_expired_at
    return if self.expired_at
    
    if self.approved?
      lifetime = Rails.application.config.default_vacancy_lifetime
      self.expired_at = Time.now + lifetime
    end
  end

  def generate_edit_token
    token = Vacancy.friendly_token
    while Vacancy.find(:first, :conditions => {:edit_token => token})
      token = Vacancy.friendly_token
    end
    self.edit_token = token
  end

  def render_body
    self.rendered_body = Redcarpet::Markdown.new(Redcarpet::Render::Appletunity)\
                                            .render(self.body)
  end
end