class RemovePlanTypeAndDayOfWeekFromWeeklyMenus < ActiveRecord::Migration[7.2]
  def change
    remove_column :weekly_menus, :plan_type, :string
    remove_column :weekly_menus, :day_of_week, :string
  end
end
