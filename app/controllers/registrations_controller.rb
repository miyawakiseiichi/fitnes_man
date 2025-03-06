class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if resource.save
      flash[:notice] = "ユーザー登録が完了しました！"
      sign_up(resource_name, resource)
      redirect_to after_sign_up_path_for(resource) # mypage_path にリダイレクト
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
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :plan_id, :frequency_id)
  end

  def after_sign_up_path_for(resource)
    mypage_path  # 新規登録後のリダイレクト先をマイページに
  end
end
