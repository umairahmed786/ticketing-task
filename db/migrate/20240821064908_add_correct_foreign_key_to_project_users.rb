class AddCorrectForeignKeyToProjectUsers < ActiveRecord::Migration[6.1]
  def change
    # Drop the foreign key constraint by name using raw SQL
    execute <<-SQL
      ALTER TABLE project_users DROP FOREIGN KEY fk_rails_1bf16ed5d0;
    SQL

    # Add the correct foreign key constraint
    add_foreign_key :project_users, :projects, column: :project_id, on_delete: :cascade
  end
end
