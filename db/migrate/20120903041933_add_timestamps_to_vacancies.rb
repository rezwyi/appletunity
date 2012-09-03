class AddTimestampsToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :created_at, :datetime, :null => false
    add_column :vacancies, :updated_at, :datetime, :null => false
  end
end