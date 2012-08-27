class Company < ActiveRecord::Base
  has_many :vacancies_companies
  has_many :vacancies, :through => :vacancies_companies

  validates :name, :presence => true
end