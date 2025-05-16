class AddRepsAndSetsToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :reps, :integer unless column_exists?(:tasks, :reps)
    add_column :tasks, :sets, :integer unless column_exists?(:tasks, :sets)
  end
end
