class AddOmniauthToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :uid, :string unless column_exists?(:users, :uid)
  end
end
