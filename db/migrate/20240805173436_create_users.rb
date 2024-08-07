class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.references :role, null: false, foreign_key: { to_table: :look_ups }
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
