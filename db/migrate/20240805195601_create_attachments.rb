class CreateAttachments < ActiveRecord::Migration[6.1]
  def change
    create_table :attachments do |t|
      t.string :file_path
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
