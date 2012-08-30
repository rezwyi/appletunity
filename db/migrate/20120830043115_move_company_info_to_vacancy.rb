class MoveCompanyInfoToVacancy < ActiveRecord::Migration
  def up
    drop_table :companies 
    add_column :vacancies, :company_name, :string
    add_column :vacancies, :company_website, :string
  end

  def down
    remove_column :vacancies, :company_name
    remove_column :vacancies, :company_website
    create_table :companies do |t|
      t.column :name, :string, :limit => 255, :null => false
      t.column :site_url, :string, :limit => 255
    end
  end
end
