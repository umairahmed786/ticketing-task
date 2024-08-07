class CreateFieldChanges < ActiveRecord::Migration[6.1]
  def change
    create_table :field_changes do |t|
      t.string :field
      t.string :old_value
      t.string :new_value
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
