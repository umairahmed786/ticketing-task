class CreateIssueHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :issue_histories do |t|
      t.references :fieldChange, foreign_key: { to_table: :field_changes }
      t.references :attachment, foreign_key: { to_table: :attachments }
      t.references :comment, foreign_key: { to_table: :comments }
      t.references :issue, null: false, foreign_key: { to_table: :issues }
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
