class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations, :dependent => :destroy
  has_many :occupations, :through => :vacancies_occupations

  validates :title, :description, :contact_email, :agreed_to_offer,
            :presence => true
end