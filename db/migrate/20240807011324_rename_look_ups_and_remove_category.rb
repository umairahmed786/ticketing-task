class RenameLookUpsAndRemoveCategory < ActiveRecord::Migration[6.1]
  def change
    rename_table :look_ups, :roles
    remove_column :roles, :category, :string
  end
end
