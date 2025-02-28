class User < ApplicationRecord
  belongs_to :plan
  belongs_to :frequency
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :frequency_id, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || password.present? }
end
