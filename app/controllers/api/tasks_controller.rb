class Api::TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :update, :destroy, :mark_complete] # 👈 Add mark_complete

  # Skip CSRF protection for API endpoints
  skip_before_action :verify_authenticity_token

  def index
    @status_filter = params[:status]

    @tasks = if @status_filter.present? && %w[open in_progress done overdue].include?(@status_filter)
              current_user.tasks.includes(:status).order(due_date: :asc).select { |t| t.display_status == @status_filter }
            else
              current_user.tasks.includes(:status).order(due_date: :asc)
            end

    tasks_json = @tasks.map do |task|
    task.as_json(
      only: [:id, :title, :description, :due_date],
      include: {
        status: { only: [:id, :name] },
        priority: { only: [:id, :name] }
      }
    ).merge(
      display_status: task.display_status,
      assignee: task.assignee_name
    )
  end


    render json: tasks_json
  end

  def show
    task_data = @task.as_json(
      only: [:id, :title, :description, :due_date, :priority, :reminder_option, :created_at],
      include: {
        subtasks: { only: [:id, :title, :completed] }
      }
    )

    task_data[:status] = {
      id: @task.status&.id || 0,
      name: @task.display_status || 'open'
    }

    task_data[:priority] = {
      id: @task.priority&.id,
      name: @task.priority&.name
    }


    task_data[:assignee_name] = @task.assignee&.name
    task_data[:assignee_email] = @task.assignee&.email
    task_data[:creator_name] = @task.user.name
    task_data[:creator_email] = @task.user.email
    task_data[:attachments] = @task.attachments.map { |file| url_for(file) }

    render json: task_data
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      response_data = @task.as_json(
        only: [:id, :title, :description, :due_date, :reminder_option, :created_at],
        include: {
          status: { only: [:id, :name] },
          priority: { only: [:id, :name] }
        }
      ).merge(
        display_status: @task.display_status,
        assignee: @task.assignee_name
      )

      if @task.attachments.any?
        response_data['attachments'] = @task.attachments.map do |attachment|
          {
            id: attachment.id,
            filename: attachment.filename.to_s,
            url: url_for(attachment)
          }
        end
      end

      render json: response_data, status: :created
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    if @task.update(task_params)
      # 👈 FIX: Return consistent format like other methods
      render json: {
        id: @task.id,
        status: {
          id: @task.status.id,
          name: @task.status.name
        },
        display_status: @task.display_status
      }
    else
      render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    head :no_content
  end

  # 👈 FIX: Make sure this method is properly defined
  def mark_complete
    @task = current_user.tasks.find(params[:id])
    done_status = Status.find_by(name: 'done')

    if done_status && @task.update(status: done_status)
      render json: {
        status: {
          id: done_status.id,
          name: done_status.name
        },
        display_status: @task.display_status
      }
    else
      render json: { error: 'Failed to mark as complete' }, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title,
      :description,
      :assignee_id,
      :due_date,
      :priority_id,  # ✅ Fix this
      :status_id,
      :reminder_option,
      attachments: [],
      subtasks_attributes: [:id, :title, :completed, :_destroy]
    )
  end
end
