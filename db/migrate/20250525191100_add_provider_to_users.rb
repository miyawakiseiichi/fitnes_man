class AddProviderToUsers < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:users, :provider)
      add_column :users, :provider, :string
    end

    unless column_exists?(:users, :uid)
      add_column :users, :uid, :string
    end

    unless index_exists?(:users, [ :provider, :uid ])
      add_index :users, [ :provider, :uid ], unique: true
    end
  end
end
