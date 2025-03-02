class WeeklyMenu < ApplicationRecord
  belongs_to :plan

  def day_name
    %w[月 火 水 木 金 土 日][day_of_week]
  end
end
