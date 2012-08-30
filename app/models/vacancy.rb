class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations, :dependent => :destroy
  has_many :occupations, :through => :vacancies_occupations
  belongs_to :company

  validates :title, :description, :contact_email, :agreed_to_offer,
            :presence => true
end