class CreateFromTransitions < ActiveRecord::Migration[6.1]
  def change
    create_table :from_transitions do |t|
      t.references :state, null: false, foreign_key: { to_table: :states }
      t.references :transition, null: false, foreign_key: true
      t.references :organization, null: false
      t.timestamps
    end
  end
end