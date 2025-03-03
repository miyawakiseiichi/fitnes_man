class AddPlanIdToUsers < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:users, :plan_id)  # ✅ すでにカラムがある場合はスキップ
      add_column :users, :plan_id, :integer
    end
  end
end
