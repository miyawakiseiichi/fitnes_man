class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    Rails.logger.info "Starting Google OAuth callback"
    Rails.logger.info "Request parameters: #{request.params.inspect}"
    Rails.logger.info "Request env: #{request.env['omniauth.auth'].to_json}" if request.env["omniauth.auth"]

    begin
      auth = request.env["omniauth.auth"]
      # まず、既存のユーザーを検索
      @user = User.find_by(email: auth.info.email)

      if @user
        # 既存ユーザーの場合
        @user.update(
          provider: auth.provider,
          uid: auth.uid,
          name: auth.info.name
        )
        flash[:notice] = "ログインしました"
        sign_in_and_redirect @user, event: :authentication
      else
        # 新規ユーザーの場合、セッションにGoogle認証情報を保存して登録画面へ
        Rails.logger.info "New user registration required"
        session["devise.google_data"] = {
          email: auth.info.email,
          name: auth.info.name,
          username: auth.info.email.split("@").first,
          provider: auth.provider,
          uid: auth.uid
        }
        flash[:notice] = "アカウント情報を入力して登録を完了してください"
        redirect_to new_user_registration_path
      end
    rescue => e
      Rails.logger.error "Error in google_oauth2 callback: #{e.message}\n#{e.backtrace.join("\n")}"
      redirect_to root_path, alert: "認証中にエラーが発生しました。もう一度お試しください。"
    end
  end

  def failure
    Rails.logger.error "OAuth failure: #{failure_message}"
    Rails.logger.error "OAuth failure params: #{params.inspect}"
    redirect_to root_path, alert: "認証に失敗しました。もう一度お試しください。"
  end

  def passthru
    Rails.logger.info "Passthru called with params: #{params.inspect}"
    super
  end

  protected

  def after_omniauth_failure_path_for(scope)
    root_path
  end
end
