class AddCompletedToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :completed, :boolean unless column_exists?(:tasks, :completed)
  end
end
