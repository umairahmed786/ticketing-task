class AddInitialToState < ActiveRecord::Migration[6.1]
  def change
    add_column :states, :initial, :boolean, default: false
  end
end
