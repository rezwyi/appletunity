class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations
  has_many :occupations, :through => :vacancies_occupations
  has_one :vacancies_city
  has_one :city, :through => :vacancies_city
  belongs_to :company

  validates :title, :description, :contact_email, :agreed_to_offer, :expired_at,
            :edit_token, :presence => true
end