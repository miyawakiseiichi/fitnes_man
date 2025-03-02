class AddPlanTypeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :plan_type, :string
  end
end
