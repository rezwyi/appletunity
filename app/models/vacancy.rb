class Vacancy < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  has_many :vacancies_occupations, :dependent => :destroy
  has_many :occupations, :through => :vacancies_occupations

  validates :title, :presence => true, :length => {:maximum => 70}
  validates :body, :presence => true
  validates :company_name, :presence => true, :length => {:maximum => 30}
  validates :contact_email, :presence => true, :format => {:with => Devise.email_regexp}
  validates :agreed_to_offer, :presence => true
  validates :edit_token, :uniqueness => true

  attr_accessible :company_name, :company_website, :title, :body, :location,
                  :occupation_ids, :contact_email, :contact_phone,
                  :agreed_to_offer, :logo

  before_create :generate_edit_token
  before_save :render_body
  before_save :generate_expired_at

  has_attached_file :logo, :styles => {:small => '80x80', :medium => '100x100'}

  scope :live, -> { where(:approved => true) }
  scope :awaiting_approve, -> { where(:approved => false) }

  def self.friendly_token
    SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
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
      self.expired_at = Time.now + Rails.application.config.default_vacancy_lifetime
    end
  end

  def generate_edit_token
    token = Vacancy.friendly_token
    while Vacancy.where(:edit_token => token).any?
      token = Vacancy.friendly_token
    end
    self.edit_token = token
  end

  def render_body
    allowed_tags = %w(h1 h2 h3 h4 p pre blockquote div ul ol li b i em strike strong)
    self.rendered_body = sanitize(self.body, :tags => allowed_tags)
  end
end
