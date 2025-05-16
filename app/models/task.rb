class Task < ApplicationRecord
  belongs_to :user
  validates :reps, numericality: { only_integer: true, greater_than: 0 }
  validates :sets, numericality: { only_integer: true, greater_than: 0 }
  validates :name, presence: true
end
