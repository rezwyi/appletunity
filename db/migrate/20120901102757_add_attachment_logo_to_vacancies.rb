class AddAttachmentLogoToVacancies < ActiveRecord::Migration
  def self.up
    change_table :vacancies do |t|
      t.has_attached_file :logo
    end
  end

  def self.down
    drop_attached_file :vacancies, :logo
  end
end
