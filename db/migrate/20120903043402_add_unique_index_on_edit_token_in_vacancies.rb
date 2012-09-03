class AddUniqueIndexOnEditTokenInVacancies < ActiveRecord::Migration
  def change
    add_index :vacancies, :edit_token, :unique => true
  end
end