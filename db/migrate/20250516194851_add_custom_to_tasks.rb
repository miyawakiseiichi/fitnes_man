class AddCustomToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :custom, :boolean
  end
end
