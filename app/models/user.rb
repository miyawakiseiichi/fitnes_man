class User < ApplicationRecord
  has_many :plans, dependent: :destroy
  belongs_to :plan, optional: true
  belongs_to :frequency
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :frequency_id, presence: { message: "を選択してください" }
  validates :plan, presence: { message: "を選択してください" }
end
