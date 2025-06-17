class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @status_filter = params[:status]

    @tasks = if @status_filter.present? && %w[pending in_progress done].include?(@status_filter)
               current_user.tasks.where(status: @status_filter).order(due_date: :asc)
             else
               current_user.tasks.order(due_date: :asc)
             end

    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      render json: @task, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :assignee_id, :status, :due_date)
  end
end
