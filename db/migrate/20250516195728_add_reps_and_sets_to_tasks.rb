class AddRepsAndSetsToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :reps, :integer
    add_column :tasks, :sets, :integer
  end
end
