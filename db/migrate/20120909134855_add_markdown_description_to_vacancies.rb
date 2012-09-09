class AddMarkdownDescriptionToVacancies < ActiveRecord::Migration
  def up
    rename_column :vacancies, :description, :body
    add_column :vacancies, :rendered_body, :text, :null => false
  end

  def down
    rename_column :vacancies, :body, :description
    remove_column :vacancies, :rendered_body
  end
end
