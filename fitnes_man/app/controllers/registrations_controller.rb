class RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      user.plan_id ||= Plan.first&.id  # ✅ `plan_id` が空ならデフォルト値を設定
    end
  end

  protected

  def after_sign_up_path_for(resource)
    mypage_path  # 新規登録後のリダイレクト先をマイページに
  end
end
