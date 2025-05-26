class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    super
    if session["devise.google_data"].present?
      auth_data = session["devise.google_data"]
      Rails.logger.debug "==== Google Auth Data Debug ===="
      Rails.logger.debug "Auth data: #{auth_data.inspect}"
      Rails.logger.debug "================================"
      
      begin
        if auth_data.present?
          resource.email = auth_data["email"]
          resource.username = auth_data["username"] || auth_data["email"]&.split('@')&.first
        end
      rescue => e
        Rails.logger.error "Error setting user data: #{e.message}"
        Rails.logger.error "Auth data structure: #{auth_data.inspect}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end

  def create
    build_resource(sign_up_params)

    # Google認証情報がある場合は設定
    if session["devise.google_data"].present?
      auth_data = session["devise.google_data"]
      Rails.logger.debug "==== Create Action Google Auth Data ===="
      Rails.logger.debug "Auth data: #{auth_data.inspect}"
      Rails.logger.debug "================================"
      
      begin
        resource.email = auth_data["email"] if resource.email.blank?
        resource.username = auth_data["username"] || auth_data["email"]&.split('@')&.first if resource.username.blank?
        
        # OAuth関連のデータを設定
        if User.column_names.include?('provider') && User.column_names.include?('uid')
          resource.provider = auth_data["provider"]
          resource.uid = auth_data["uid"]
        end
      rescue => e
        Rails.logger.error "Error setting resource data: #{e.message}"
        Rails.logger.error "Auth data structure: #{auth_data.inspect}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end

    if resource.save
      session["devise.google_data"] = nil
      flash[:notice] = "ユーザー登録が完了しました！"
      sign_up(resource_name, resource)
      redirect_to mypage_path
    else
      flash.now[:alert] = resource.errors.full_messages.join("、")
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :frequency_id, :plan_id])
  end

  def sign_up_params
    base_params = [:username, :email, :password, :password_confirmation, :plan_id, :frequency_id]
    # providerとuidカラムが存在する場合のみ許可
    if User.column_names.include?('provider') && User.column_names.include?('uid')
      base_params += [:provider, :uid]
    end
    params.require(:user).permit(base_params)
  end

  def after_sign_up_path_for(resource)
    mypage_path
  end
end
