class WeeklyMenu < ApplicationRecord
  belongs_to :plan
  validates :scheduled_date, presence: true

  def day_name
    scheduled_date&.strftime("%A")
  end

  def self.for_week(date = Date.today)
    start_date = date.beginning_of_week
    end_date = date.end_of_week
    where(scheduled_date: start_date..end_date)
  end
end
