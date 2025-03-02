class AddPlanIdToWeeklyMenus < ActiveRecord::Migration[7.2]
  def change
    add_column :weekly_menus, :plan_id, :integer
  end
end
