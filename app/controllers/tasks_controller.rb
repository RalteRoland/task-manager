class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # Skip CSRF protection for API endpoints
  skip_before_action :verify_authenticity_token

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
  task_data = @task.as_json(include: {
    subtasks: { only: [:id, :title] }
  })

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
      # Include attachments in the response if they exist
      response_data = @task.as_json
      if @task.attachments.any?
        response_data['attachments'] = @task.attachments.map do |attachment|
          {
            id: attachment.id,
            filename: attachment.filename.to_s,
            url: url_for(attachment) # This generates a URL to access the file
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
      # Include attachments in the response if they exist
      response_data = @task.as_json
      if @task.attachments.any?
        response_data['attachments'] = @task.attachments.map do |attachment|
          {
            id: attachment.id,
            filename: attachment.filename.to_s,
            url: url_for(attachment)
          }
        end
      end

      render json: response_data
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
    params.require(:task).permit(
      :title,
      :description,
      :assignee_id,
      :due_date,
      :status,
      attachments: [],
      subtasks_attributes: [:id, :title, :_destroy]
    )
  end

end
