class AddFrequencyIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :frequency_id, :integer, null: false, default: 4
  end
end
