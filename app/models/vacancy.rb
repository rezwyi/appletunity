class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations, :dependent => :destroy
  has_many :occupations, :through => :vacancies_occupations

  validates :title, :description, :contact_email, :agreed_to_offer,
            :presence => true

  attr_accessible :company_name, :company_website, :title, :description,
                  :location, :occupations, :contact_email, :contact_phone,
                  :agreed_to_offer
end