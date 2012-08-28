class ChangeVacancyCityAssociation < ActiveRecord::Migration
  def change
  	change_table :vacancies do |t|
  		t.references :city
  	end
  end
end
