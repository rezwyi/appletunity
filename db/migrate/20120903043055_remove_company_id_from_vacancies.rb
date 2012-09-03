class RemoveCompanyIdFromVacancies < ActiveRecord::Migration
  def up
    remove_column :vacancies, :company_id
  end

  def down
    add_column :vacancies, :company_id, :integer
  end
end