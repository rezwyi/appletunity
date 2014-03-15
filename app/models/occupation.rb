class Occupation < ActiveRecord::Base
  has_many :occupationables, dependent: :destroy
  has_many :vacancies, through: :occupationables

  validates :name, presence: true
  validates :name, uniqueness: true
end