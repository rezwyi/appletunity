class ChangeVacancyOccupationsAssociation < ActiveRecord::Migration
  def change
  	drop_table :vacancies_occupations
  	create_table :vacancies_occupations do |t|
  	  t.belongs_to :vacancy
  	  t.belongs_to :occupation
  	end
  end
end
