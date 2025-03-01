class Plan < ApplicationRecord
  belongs_to :user, optional: true
  has_one :users
end
