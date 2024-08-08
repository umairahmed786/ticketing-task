class UpdateIssueHistoriesForActiveStorage < ActiveRecord::Migration[6.1]
  def change
    remove_reference :issue_histories, :attachment, foreign_key: { to_table: :attachments }

    add_reference :issue_histories, :active_storage_attachment, foreign_key: { to_table: :active_storage_attachments }, index: true
  end
end
