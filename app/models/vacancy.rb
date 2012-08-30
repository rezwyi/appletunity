class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations, :dependent => :destroy
  has_many :occupations, :through => :vacancies_occupations

  validates :title, :description, :contact_email, :agreed_to_offer,
            :presence => true

  attr_accessible :company_name, :company_website, :title, :description,
                  :location, :occupations, :contact_email, :contact_phone,
                  :agreed_to_offer

  before_save :generate_expired_at
  before_save :generate_edit_token

  # Simple random token generator
  def self.friendly_token
    SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
  end

  # Crops vacancy description to 140 symbols
  def short_description
    if self.description.length > 140
      "#{self.description[0,137]}..."
    else
      self.description
    end
  end

  protected

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