class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)  # Devise を使って自動ログイン
      redirect_to mypage_path, notice: "ユーザー登録が完了しました！"
    else
      flash.now[:alert] = @user.errors.full_messages.join("、")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @user = current_user → set_user で取得済み
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "プロフィールが更新されました！"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    sign_out(@user)  # Deviseのセッションも削除
    redirect_to root_path, notice: "アカウントが削除されました"
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
