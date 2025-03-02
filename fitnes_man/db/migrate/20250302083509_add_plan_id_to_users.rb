class AddPlanIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :plan_id, :integer
    add_foreign_key :users, :plans
  end
end
