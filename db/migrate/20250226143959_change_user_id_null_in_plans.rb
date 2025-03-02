class ChangeUserIdNullInPlans < ActiveRecord::Migration[7.2]
  def change
    change_column_null :plans, :user_id, true
  end
end
