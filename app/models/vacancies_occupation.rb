class VacanciesOccupation < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :occupation
end