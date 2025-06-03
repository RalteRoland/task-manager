class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks_count = current_user.tasks.count
    @pending_count = current_user.tasks.where(status: "pending").count
    @in_progress_count = current_user.tasks.where(status: "in_progress").count
    @done_count = current_user.tasks.where(status: "done").count

    @upcoming_tasks = current_user.tasks.where("due_date >= ?", Date.today).order(:due_date).limit(5)
  end
end
