class CreateIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :issues do |t|
      t.string :title
      t.text :description
      t.string :state
      t.integer :complexity_point
      t.references :project, null: false, foreign_key: { to_table: :projects }
      t.references :assignee, foreign_key: { to_table: :users }
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
