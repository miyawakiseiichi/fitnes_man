class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    super
    if session["devise.google_data"].present?
      @user.email = session["devise.google_data"]["email"]
      @user.name = session["devise.google_data"]["name"]
      @user.username = session["devise.google_data"]["username"]
    end
  end

  def create
    build_resource(sign_up_params)

    # Google認証情報がある場合は設定（カラムの存在を確認）
    if session["devise.google_data"].present? && 
       User.column_names.include?('provider') && 
       User.column_names.include?('uid')
      resource.provider = session["devise.google_data"]["provider"]
      resource.uid = session["devise.google_data"]["uid"]
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :name, :frequency_id, :plan_id])
  end

  def sign_up_params
    base_params = [:username, :email, :password, :password_confirmation, :plan_id, :frequency_id, :name]
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
