class WeeklyMenusController < ApplicationController
  before_action :set_weekly_menu, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @start_date = @date.beginning_of_month.beginning_of_week(:sunday)
    @end_date = @date.end_of_month.end_of_week(:sunday)
    @plan = current_user.plan
    @frequency = current_user.frequency
    
    # プランと頻度に関連する全てのメニューを取得
    if @plan && @frequency
      @weekly_menus = WeeklyMenu.for_plan_and_frequency(@plan, @frequency)
      @plan_menus = @weekly_menus.group_by { |menu| menu.scheduled_date&.wday || 0 }
      
      # メニューがない場合の処理
      if @weekly_menus.empty?
        @menus_by_day = {}
        flash.now[:info] = "現在のプラン「#{@plan.title}」と頻度「#{@frequency.name}」に対応するメニューがありません。"
      else
        @menus_by_day = @plan_menus
      end
    else
      @weekly_menus = []
      @plan_menus = {}
      @menus_by_day = {}
      
      if @plan.nil?
        flash.now[:warning] = "プランを選択してください。"
      elsif @frequency.nil?
        flash.now[:warning] = "トレーニング頻度を選択してください。"
      end
    end
  end

  def show
  end

  def new
    @weekly_menu = WeeklyMenu.new
  end

  def edit
  end

  def create
    @weekly_menu = WeeklyMenu.new(weekly_menu_params)

    if @weekly_menu.save
      redirect_to @weekly_menu, notice: "トレーニングメニューが作成されました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @weekly_menu.update(weekly_menu_params)
      redirect_to @weekly_menu, notice: "トレーニングメニューが更新されました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @weekly_menu.destroy
    redirect_to weekly_menus_url, notice: "トレーニングメニューが削除されました。"
  end

  private
    def set_weekly_menu
      @weekly_menu = WeeklyMenu.find(params[:id])
    end

    def weekly_menu_params
      params.require(:weekly_menu).permit(:name, :description, :scheduled_date, :plan_id, :frequency_id)
    end
end
