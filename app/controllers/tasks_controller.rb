class TasksController < ApplicationController
  before_action :authenticate_user!      # Require login for all actions
  before_action :set_task, only: [ :edit, :update, :destroy ]

  def index
    @status_filter = params[:status]

    if @status_filter.present? && %w[pending in_progress done].include?(@status_filter)
      @tasks = current_user.tasks.where(status: @status_filter).order(due_date: :asc)
    else
      @tasks = current_user.tasks.order(due_date: :asc)
    end
  end


  def new
    # Initialize a new task linked to the current user
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: "Task created successfully!"
    else
      render :new, status: :unprocessable_entity  # 👈 this is key
    end
  end


  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: "Task updated!"
    else
      render :edit
    end
  end


  def show
    @task = current_user.tasks.find(params[:id])
  end


  def destroy
    @task.destroy
    redirect_to tasks_path, notice: "Task deleted."
  end

  private

  # Finds task belonging to current user by id, or raises error if not found
  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  # Strong params: allow only specific fields from form
  def task_params
    params.require(:task).permit(:title, :description, :status, :due_date)
  end
end
