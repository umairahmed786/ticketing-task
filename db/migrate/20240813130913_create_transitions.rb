class CreateTransitions < ActiveRecord::Migration[6.1]
  def change
    create_table :transitions do |t|
      t.string :event_name, null: false
      t.references :to_state, foreign_key: { to_table: :states }, null: false
      t.references :organization, foreign_key: true, null: false
      t.boolean :notify, default: false
      t.timestamps
    end
  end
end