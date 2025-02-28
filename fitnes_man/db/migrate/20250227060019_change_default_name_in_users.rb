class ChangeDefaultNameInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :name, ""
  end
end
