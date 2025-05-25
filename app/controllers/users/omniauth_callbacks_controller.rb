class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    Rails.logger.info "Starting Google OAuth callback"
    Rails.logger.info "Request parameters: #{request.params.inspect}"
    Rails.logger.info "Request env: #{request.env['omniauth.auth'].to_json}" if request.env['omniauth.auth']

    begin
      @user = User.from_omniauth(request.env['omniauth.auth'])
      
      Rails.logger.info "User object: #{@user.inspect}"

      if @user.persisted?
        # 既存ユーザーの場合
        if @user.provider.present? && @user.uid.present?
          Rails.logger.info "User successfully authenticated and linked with Google"
          flash[:notice] = 'Googleアカウントと連携しました'
        else
          Rails.logger.info "User successfully authenticated"
          flash[:notice] = 'ログインしました'
        end
        sign_in_and_redirect @user, event: :authentication
      else
        # 新規ユーザーの場合、セッションにGoogle認証情報を保存して登録画面へ
        Rails.logger.info "New user registration required"
        session["devise.google_data"] = {
          email: @user.email,
          name: @user.name,
          username: @user.username,
          provider: @user.provider,
          uid: @user.uid
        }
        redirect_to new_user_registration_url, notice: 'アカウント情報を入力して登録を完了してください'
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