class Occupationable < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :occupation
  
  accepts_nested_attributes_for :occupation
end