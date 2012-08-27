class Region < ActiveRecord::Base
  has_many :cities
  validates :name, :presence => true
end