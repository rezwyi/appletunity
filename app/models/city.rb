class City < ActiveRecord::Base
  has_many :vacancies_cities
  has_many :vacancies, :through => :vacancies_cities
  has_one :region
end