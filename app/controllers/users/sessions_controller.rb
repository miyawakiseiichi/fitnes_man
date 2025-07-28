class Users::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      sign_in(resource_name, resource)
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash[:alert] = "メールアドレスまたはパスワードが正しくありません。"
      redirect_to new_user_session_path
    end
  rescue => e
    Rails.logger.error "Login error: #{e.message}"
    flash[:alert] = "ログインに失敗しました。もう一度お試しください。"
    redirect_to new_user_session_path
  end

  protected

  def after_sign_in_path_for(resource)
    if resource.plan.present?
      plans_path
    else
      root_path
    end
  end
end
