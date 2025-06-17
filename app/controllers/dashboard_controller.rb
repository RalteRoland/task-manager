class DashboardController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :null_session

  def index
    render json: {
      tasks_count: current_user.tasks.count,
      pending_count: current_user.tasks.where(status: "pending").count,
      in_progress_count: current_user.tasks.where(status: "in_progress").count,
      done_count: current_user.tasks.where(status: "done").count,
      all_tasks: current_user.tasks.order(due_date: :asc),
      completed_tasks: current_user.tasks.where(status: "done").order(updated_at: :desc).limit(5)
    }
  end
end
