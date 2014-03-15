class RenameVacanciesLogoAttachment < ActiveRecord::Migration
  def up
    rename_column :vacancies, :logo_file_name, :inline_logo_file_name
    rename_column :vacancies, :logo_file_size, :inline_logo_file_size
    rename_column :vacancies, :logo_content_type, :inline_logo_content_type
    rename_column :vacancies, :logo_updated_at, :inline_logo_updated_at

    FileUtils.mv(
      Rails.root.join('public', 'system', 'vacancies', 'logos'),
      Rails.root.join('public', 'system', 'vacancies', 'inline_logos')
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
