class UpdateForeignKeyOnIssueHistories < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :issue_histories, :comments
    add_foreign_key :issue_histories, :comments, on_delete: :cascade
  end
end
