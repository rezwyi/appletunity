class AddApprovedToVacancies < ActiveRecord::Migration
  def up
    add_column :vacancies, :approved, :boolean
    change_column :vacancies, :expired_at, :datetime, :null => true
  end

  def down
    remove_column :vacancies, :approved
    change_column :vacancies, :expired_at, :datetime, :null => false
  end
end
