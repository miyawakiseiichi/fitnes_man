class AddFrequencyIdToWeeklyMenus < ActiveRecord::Migration[7.2]
  def change
    add_reference :weekly_menus, :frequency, null: false, foreign_key: true
  end
end
