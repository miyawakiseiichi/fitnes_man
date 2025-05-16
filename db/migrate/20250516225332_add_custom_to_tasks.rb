class AddCustomToTasks < ActiveRecord::Migration[7.2]
  def change
    # 既に存在する場合は追加しない
    add_column :tasks, :custom, :boolean unless column_exists?(:tasks, :custom)
  end
end
