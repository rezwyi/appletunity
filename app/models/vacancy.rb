class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations, :dependent => :destroy
  has_many :occupations, :through => :vacancies_occupations

  validates :title, :description, :company_name, :contact_email,
            :agreed_to_offer, :presence => true

  validates :edit_token, :uniqueness => true

  attr_accessible :company_name, :company_website, :title, :description,
                  :location, :occupation_ids, :contact_email, :contact_phone,
                  :agreed_to_offer, :logo

  before_save :generate_expired_at, :if => :new_record?
  before_save :generate_edit_token, :if => :new_record?

  has_attached_file :logo,
                    :styles => {:small => '80x80', :medium => '100x100'}

  # Simple random token generator
  def self.friendly_token
    SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
  end

  def to_param
    "#{self.id.to_s}-#{self.ascii_title}"
  end

  protected

  def ascii_title
    title = self.title.split(' ').map do |w|
      Russian::translit(w).downcase.gsub(/\W/,'-').strip
    end
    title.join('-').gsub(/[-]+/, '-').gsub(/^-/, '').gsub(/-$/, '')
  end

  def generate_expired_at
    self.expired_at = Time.now + 7.days
  end

  def generate_edit_token
    token = Vacancy.friendly_token
    while Vacancy.find(:first, :conditions => {:edit_token => token})
      token = Vacancy.friendly_token
    end
    self.edit_token = token
  end
end