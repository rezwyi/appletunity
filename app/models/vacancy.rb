class Vacancy < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  ALLOWED_TAGS = %w(h1 h2 h3 h4 p pre blockquote div ul ol li b i em strike strong)

  has_many :occupationables, dependent: :destroy
  has_many :occupations, through: :occupationables

  accepts_nested_attributes_for :occupationables, allow_destroy: true

  validates :title, presence: true, length: {maximum: 70}
  validates :body, presence: true
  validates :company_name, presence: true, length: {maximum: 30}
  validates :contact_email, presence: true, format: {with: Devise.email_regexp}
  validates :agreed_to_offer, presence: true
  validates :edit_token, uniqueness: true

  before_validation :fix_body
  before_create :generate_edit_token
  before_save :generate_expired_at

  after_create do
    Resque.enqueue VacancyNotificationsWorker, self.id
  end

  after_save do
    if self.expired_at && self.expired_at_changed?
      Resque.enqueue TwitterNotificationsWorker, self.id
    end
  end

  paginates_per 25
  
  has_attached_file :logo, styles: {small: '80x80', medium: '100x100'}
  validates_attachment_content_type :logo, content_type: %w(image/jpeg image/jpg image/png)

  scope :live, -> { where(approved: true) }
  scope :awaiting_approve, -> { where(approved: false) }

  def self.friendly_token
    SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
  end

  def to_param
    "#{self.id}-#{ascii_title}"
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

  def fix_body
    self.body.gsub!(/\A\<p\>\<br\>\<\/p\>\Z/, '') if self.body
    self.rendered_body = sanitize(self.body, tags: ALLOWED_TAGS)
  end

  def generate_expired_at
    return if self.expired_at
    if self.approved?
      self.expired_at = Time.now + Settings.vacancies.lifetime.days
    end
  end

  def generate_edit_token
    token = Vacancy.friendly_token
    while Vacancy.where(edit_token: token).any?
      token = Vacancy.friendly_token
    end
    self.edit_token = token
  end
end