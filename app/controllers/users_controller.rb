class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id  # ログイン状態にする
      redirect_to mypage_path, notice: "ユーザー登録が完了しました！"
    else
      flash.now[:alert] = @user.errors.full_messages.join("、")
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
    @plans = Plan.all
    @frequencies = Frequency.all
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'プロフィールが更新されました。'
    else
      @plans = Plan.all
      @frequencies = Frequency.all
      render :edit
    end
  end

  def destroy
    @user.destroy
    reset_session  # ログアウト
    redirect_to root_path, notice: "アカウントが削除されました"
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :username, :plan_id, :frequency_id)
  end
end
