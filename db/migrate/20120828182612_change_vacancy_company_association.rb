class ChangeVacancyCompanyAssociation < ActiveRecord::Migration
  def change
  	change_table :vacancies do |t|
  		t.references :company
  	end
  end
end
