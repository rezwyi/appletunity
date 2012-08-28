class Company < ActiveRecord::Base
  has_many :vacancies
  validates :name, :presence => true
end