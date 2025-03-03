class AddPlanTypeToWeeklyMenus < ActiveRecord::Migration[7.2]
  def change
    add_column :weekly_menus, :plan_type, :string
  end
end
