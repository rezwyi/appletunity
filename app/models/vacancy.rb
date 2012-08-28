class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations
  has_many :occupations, :through => :vacancies_occupations
  belongs_to :company
  belongs_to :city

  validates :title, :description, :contact_email, :agreed_to_offer, :expired_at,
            :edit_token, :presence => true
end