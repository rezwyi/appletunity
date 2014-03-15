class CreateLogos < ActiveRecord::Migration
  def up
    create_table :logos do |t|
      t.attachment :image
      t.string :image_fingerprint
      t.boolean :force, default: false
      t.timestamps
    end

    create_table :logoables do |t|
      t.references :resource, polymorphic: true
      t.references :logo
    end
    
    add_index :logos, :image_fingerprint
    add_index :logoables, [:resource_id, :resource_type, :logo_id], unique: true

    Vacancy.where('inline_logo_file_size is not null').each do |v|
      logo = Logo.new(image: v.inline_logo, force: true)
      Logoable.create(resource: v, logo: logo) if logo.save(validate: false)
    end
    
    rename_table :vacancies_occupations, :occupationables
  end

  def down
    remove_index :logoables, [:resource_id, :resource_type, :logo_id]
    remove_index :logos, :image_fingerprint
    drop_table :logoables
    drop_table :logos
    rename_table :occupationables, :vacancies_occupations
  end
end