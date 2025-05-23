# app/controllers/users/omniauth_callbacks_controller.rb
module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        Rails.logger.debug "✅ ユーザー認証成功: #{@user.email}"
        session[:prefill_email] = @user.email  # ✅ 成功時にもメールをセット
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect @user, event: :authentication
      else
        Rails.logger.debug "❌ ユーザー保存失敗: #{@user.errors.full_messages.join(', ')}"
        session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
        session[:prefill_email] = request.env['omniauth.auth'].info.email
        redirect_to new_user_session_path, alert: @user.errors.full_messages.join("\n")
      end
    end
  end
end
