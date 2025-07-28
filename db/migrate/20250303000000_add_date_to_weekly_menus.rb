class AddDateToWeeklyMenus < ActiveRecord::Migration[7.2]
  def change
    add_column :weekly_menus, :scheduled_date, :date
  end
end
