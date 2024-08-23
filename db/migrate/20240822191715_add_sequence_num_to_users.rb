class AddSequenceNumToUsers < ActiveRecord::Migration[6.1]
  def self.up
    add_column :users, :sequence_num, :integer, null: false
    update_sequence_num_values
    add_index :users, %i[sequence_num organization_id], unique: true
  end

  def self.down
    remove_index :users, column: %i[sequence_num organization_id]
    remove_column :users, :sequence_num
  end

  def self.update_sequence_num_values
    Organization.all.each do |organization|
      cntr = 1
      organization.users.reorder('id').all.each do |nested|
        nested.sequence_num = cntr
        cntr += 1
        nested.save
      end
    end
  end
end
