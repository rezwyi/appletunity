class AddDefaultApprovedValueToVacancies < ActiveRecord::Migration
  def up
    change_column :vacancies, :approved, :boolean, :null => false,
                  :default => false
  end

  def down
    change_column :vacancies, :approved, :boolean
  end
end
