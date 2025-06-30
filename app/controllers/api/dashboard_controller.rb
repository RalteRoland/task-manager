class Api::DashboardController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :null_session

  def index
    tasks = current_user.tasks.includes(:status, :assignee).order(due_date: :asc)

    tasks_with_display_status = tasks.map do |task|
      task.as_json(
        only: [:id, :title, :due_date]
      ).merge(
        'status' => task.status&.name,
        'display_status' => task.display_status,
        'assignee' => task.assignee&.name || 'Unassigned'
      )
    end

    render json: {
      tasks_count: tasks.count,
      in_progress_count: tasks.select { |t| t.status&.name == 'in_progress' }.count,
      done_count: tasks.select { |t| t.status&.name == 'done' }.count,
      overdue_count: tasks.select { |t| t.display_status == 'overdue' }.count,
      all_tasks: tasks_with_display_status,
      completed_tasks: tasks.select { |t| t.status&.name == 'done' }.sort_by(&:updated_at).reverse.take(5)
    }
  end
end
