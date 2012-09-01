class ChangeMandatoryOfCompanyNameInVacancies < ActiveRecord::Migration
  def up
    change_column :vacancies, :company_name, :string, :null => false
  end

  def down
    change_column :vacancies, :company_name, :string, :null => true
  end
end