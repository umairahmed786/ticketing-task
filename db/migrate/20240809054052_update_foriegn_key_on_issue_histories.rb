class UpdateForiegnKeyOnIssueHistories < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :issue_histories, :active_storage_attachments

    add_foreign_key :issue_histories, :active_storage_attachments, on_delete: :nullify
  end
end
