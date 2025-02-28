class AddDefaultNameToUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :name, "未設定"
  end
end
