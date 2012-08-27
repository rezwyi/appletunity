class Vacancy < ActiveRecord::Base
  has_many :vacancies_occupations
  has_many :occupations, :through => :vacancies_occupations
  has_one :vacancies_company
  has_one :company, :through => :vacancies_company
  has_one :vacancies_city
  has_one :city, :through => :vacancies_city
end