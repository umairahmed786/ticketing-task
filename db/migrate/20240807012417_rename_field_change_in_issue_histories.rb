class RenameFieldChangeInIssueHistories < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :issue_histories, column: :fieldChange_id
    rename_column :issue_histories, :fieldChange_id, :field_change_id
    add_foreign_key :issue_histories, :field_changes, column: :field_change_id
  end
end
