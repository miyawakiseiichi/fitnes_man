class Frequency < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  
  has_many :users
  has_many :weekly_menus
end
