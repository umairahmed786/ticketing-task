class AddSequenceNumToIssues < ActiveRecord::Migration[6.1]
  def self.up
    add_column :issues, :sequence_num, :integer, null: false
    update_sequence_num_values
    add_index :issues, %i[sequence_num project_id], unique: true
  end

  def self.down
    remove_index  :issues, column: %i[sequence_num project_id]
    remove_column :issues, :sequence_num
  end

  def self.update_sequence_num_values
    Project.all.each do |parent|
      cntr = 1
      parent.issues.reorder('id').all.each do |nested|
        nested.sequence_num = cntr
        cntr += 1
        nested.save
      end
    end
  end
end
