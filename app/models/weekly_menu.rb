class WeeklyMenu < ApplicationRecord
  belongs_to :plan
  belongs_to :frequency
  
  validates :name, presence: true
  validates :description, presence: true
  validates :scheduled_date, presence: true

  # スコープ: プランと頻度の組み合わせでフィルタリング
  scope :for_plan_and_frequency, ->(plan, frequency) {
    where(plan: plan, frequency: frequency)
  }
  
  # スコープ: 特定の週の範囲でフィルタリング
  scope :for_week, ->(date = Date.today) {
    start_date = date.beginning_of_week
    end_date = date.end_of_week
    where(scheduled_date: start_date..end_date)
  }

  def day_name
    scheduled_date&.strftime("%A")
  end

  def self.for_week(date = Date.today)
    start_date = date.beginning_of_week
    end_date = date.end_of_week
    where(scheduled_date: start_date..end_date)
  end
end
