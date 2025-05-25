class RegistrationsController < Devise::RegistrationsController
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

  def set_plans
    @plans = Plan.all
  end

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :plan_id, :frequency_id, :name)
  end

  def after_sign_up_path_for(resource)
    mypage_path  # 新規登録後のリダイレクト先をマイページに
  end
end
