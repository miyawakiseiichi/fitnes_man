class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :plans, dependent: :destroy
  belongs_to :plan, optional: true
  belongs_to :frequency

  # Deviseのモジュール
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # バリデーション
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :frequency_id, presence: { message: "を選択してください" }
  validates :plan, presence: { message: "を選択してください" }

  # 通常ログイン時のみパスワードを必須とする
  def password_required?
    super && provider.blank?
  end

  # Google OAuthからの情報でユーザーを作成・取得
  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)

    if user
      # 既存ユーザーにprovider/uidを追加（必要なら）
      user.update(provider: auth.provider, uid: auth.uid) if user.provider.blank? || user.uid.blank?
    else
      user = User.create(
        email: auth.info.email,
        username: auth.info.name,
        provider: auth.provider,
        uid: auth.uid,
        password: Devise.friendly_token[0, 20],
        frequency_id: Frequency.first&.id,
        plan_id: Plan.first&.id
      )
      unless user.persisted?
        Rails.logger.error("User save failed: #{user.errors.full_messages.join(', ')}")
      end
    end

    user
  end
end
