class VacanciesCompany < ActiveRecord::Base
  belongs_to :vacancy
  belongs_to :company
end