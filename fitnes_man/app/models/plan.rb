class Plan < ApplicationRecord
  belongs_to :user, optional: true  # user_id を必須にしない
  has_one :user
end
