class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # ✅ ログイン後のリダイレクト先をマイページに設定
  def after_sign_in_path_for(resource)
    puts "🔥 after_sign_in_path_for called: Redirecting to mypage_path" # 確認用ログ
    mypage_path
  end

  # ✅ プロフィール編集後のリダイレクト先もマイページ
  def after_update_path_for(resource)
    puts "🔥 after_update_path_for called: Redirecting to mypage_path" # 確認用ログ
    mypage_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :plan_id, :frequency_id ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :plan_id, :frequency_id ])
  end
end
