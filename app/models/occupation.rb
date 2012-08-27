class Occupation < ActiveRecord::Base
  has_many :vacancies_occupations
  has_many :vacancies, :through => :vacancies_occupations
end