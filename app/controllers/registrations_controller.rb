class RegistrationsController < Devise::RegistrationsController
  def create
    super  # ✅ Devise の `create` を呼び出す
  end

  protected

  def set_plans
    @plans = Plan.all
  end

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :plan_id, :frequency_id)
  end

  def after_sign_up_path_for(resource)
    mypage_path  # 新規登録後のリダイレクト先をマイページに
  end
end
