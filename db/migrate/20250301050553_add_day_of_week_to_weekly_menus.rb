class AddDayOfWeekToWeeklyMenus < ActiveRecord::Migration[7.2]
  def change
    add_column :weekly_menus, :day_of_week, :integer
  end
end
