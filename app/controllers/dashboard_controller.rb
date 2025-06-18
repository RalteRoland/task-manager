class DashboardController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :null_session

  def index
    tasks_with_display_status = current_user.tasks.includes(:assignee).order(due_date: :asc).map do |task|
      task.as_json(
        only: [:id, :title, :due_date, :status]
      ).merge(
        'display_status' => task.display_status,
        'assignee' => task.assignee&.name || 'Unassigned'
      )
    end

    render json: {
      tasks_count: current_user.tasks.count,
      # pending_count: current_user.tasks.where(status: "pending").count,  # Remove this line
      in_progress_count: current_user.tasks.where(status: "in_progress").count,
      done_count: current_user.tasks.where(status: "done").count,
      overdue_count: current_user.tasks.where("status != ? AND due_date < ?", "done", Date.today).count,
      all_tasks: tasks_with_display_status,
      completed_tasks: current_user.tasks.where(status: "done").order(updated_at: :desc).limit(5)
    }
  end
end
