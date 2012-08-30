class MoveLocationToVacancy < ActiveRecord::Migration
  def change
    remove_column :vacancies, :city_id
    add_column :vacancies, :location, :string
  end
end