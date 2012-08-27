class VacanciesCity < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :city
end