class CreateLookUps < ActiveRecord::Migration[6.1]
  def change
    create_table :look_ups do |t|
      t.string :name
      t.string :category

      t.timestamps
    end
  end
end
