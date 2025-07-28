class AddFrequencyIdToWeeklyMenus < ActiveRecord::Migration[7.2]
  def up
    # まずnull可能でカラムを追加
    add_reference :weekly_menus, :frequency, null: true, foreign_key: true

    # 既存レコードに最初の頻度を設定
    if Frequency.exists?
      default_frequency_id = Frequency.first.id
      WeeklyMenu.where(frequency_id: nil).update_all(frequency_id: default_frequency_id)
    end

    # NOT NULL制約を追加
    change_column_null :weekly_menus, :frequency_id, false
  end

  def down
    remove_reference :weekly_menus, :frequency, foreign_key: true
  end
end
