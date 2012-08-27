class DatabaseDesign < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.column :title, :string, :limit => 255, :null => false
      t.column :description, :text, :null => false
      t.column :contact_email, :string, :limit => 255, :null => false
      t.column :contact_phone, :string, :limit => 255
      t.column :agreed_to_offer, :boolean, :null => false
      t.column :expired_at, :date, :null => false
      t.column :edit_token, :string, :limit => 255, :null => false
    end

    create_table :occupations do |t|
      t.column :name, :string, :null => false
    end

    create_table :vacancies_occupations do |t|
      t.references :vacancies
      t.references :occupations
    end

    create_table :companies do |t|
      t.column :name, :string, :limit => 255, :null => false
      t.column :site_url, :string, :limit => 255
    end

    create_table :vacancies_companies do |t|
      t.references :companies
      t.references :vacancies
    end

    create_table :regions do |t|
      t.column :name, :string, :limit => 255, :null => false
    end

    create_table :cities do |t|
      t.column :name, :string, :limit => 255, :null => false
      t.references :regions
    end

    create_table :vacancies_cities do |t|
      t.references :vacancies
      t.references :cities
    end
  end
end