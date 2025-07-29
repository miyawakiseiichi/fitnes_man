class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :plans, dependent: :destroy
  belongs_to :plan
  belongs_to :frequency
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [ :google_oauth2 ]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    # 既存のユーザーを検索
    user = User.find_by(email: auth.info.email)

    if user
      # 既存のユーザーが見つかった場合、Google認証情報を更新
      user.update(
        provider: auth.provider,
        uid: auth.uid,
        name: auth.info.name
      )
      user
    else
      # 新規ユーザー用の仮オブジェクトを作成（保存はしない）
      new_user = User.new(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        name: auth.info.name,
        username: auth.info.email.split("@").first,
        provider: auth.provider,
        uid: auth.uid
      )
      new_user.skip_validation = true # バリデーションをスキップするフラグ
      new_user
    end
  end

  attr_accessor :skip_validation

  def should_validate?
    !skip_validation
  end
end
