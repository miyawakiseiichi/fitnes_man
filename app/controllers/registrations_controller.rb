class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    super do |resource|
      if session["devise.google_data"].present?
        resource.email = session["devise.google_data"]["email"]
        resource.name = session["devise.google_data"]["name"]
        resource.username = session["devise.google_data"]["username"]
      end
    end
  end

  def create
    build_resource(sign_up_params)

    # Google認証情報がある場合は設定
    if session["devise.google_data"].present?
      resource.provider = session["devise.google_data"]["provider"]
      resource.uid = session["devise.google_data"]["uid"]
    end

    if resource.save
      # Google認証情報をクリア
      session["devise.google_data"] = nil
      
      flash[:notice] = "ユーザー登録が完了しました！"
      sign_up(resource_name, resource)
      redirect_to after_sign_up_path_for(resource)
    else
      flash.now[:alert] = resource.errors.full_messages.join("、")
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :name, :frequency_id, :plan_id])
  end

  def after_sign_up_path_for(resource)
    session["devise.google_data"] = nil
    root_path
  end
end
