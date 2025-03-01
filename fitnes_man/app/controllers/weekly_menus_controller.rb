class WeeklyMenusController < ApplicationController
  before_action :authenticate_user! # ユーザー認証が必要
  before_action :set_weekly_menu, only: [:show]

  def index
    @plan = current_user.plan # ログインユーザーのプランを取得
    @frequency = current_user.frequency # ユーザーのジム利用頻度を取得

    @plan
    # 余分なスペースを削除し、比較の正確性を向上
    frequency_name = @frequency.name.strip
    # ジムの利用頻度に応じたメニュー数を制限
    menu_limit = case @frequency&.name
                 when "週1","週1回" then 1
                 when "週2~3", "週2~3回" then 3
                 when "週4~5", "週4~5回" then 5
                 when "週6~7", "週6~7回" then 7
                 else WeeklyMenu.where(plan_id: @plan.id).count
                 end

      @weekly_menus = WeeklyMenu.where(plan_id: @plan.id).limit(menu_limit)
  end

  def show
  end

  private

  def set_weekly_menu
    @weekly_menu = WeeklyMenu.find(params[:id])
  end
end
