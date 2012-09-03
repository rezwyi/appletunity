class ChangeTypeOfExpiredAtInVacancies < ActiveRecord::Migration
  def up
    change_column :vacancies, :expired_at, :datetime
  end

  def down
    change_column :vacancies, :expired_at, :date
  end
end