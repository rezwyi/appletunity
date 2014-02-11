class Occupation < ActiveRecord::Base
  has_many :vacancies_occupations
  has_many :vacancies, through: :vacancies_occupations

  validates :name, presence: true
  validates :name, uniqueness: true
end