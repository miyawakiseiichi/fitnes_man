class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks.order(created_at: :asc)
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: "タスクを追加しました！"
    else
      @tasks = current_user.tasks.order(created_at: :asc) # エラー時に再描画用
      render :index
    end
  end

  def destroy
    @task = current_user.tasks.find(params[:id])
    @task.destroy
    redirect_to tasks_path, notice: "タスクを削除しました。"
  end

  def complete
    @task = current_user.tasks.find(params[:id])
    @task.update(completed: true)
    redirect_to tasks_path, notice: "タスクを完了しました！"
  end

  private

  def task_params
    params.require(:task).permit(:name, :reps, :sets, :custom)
  end
end
