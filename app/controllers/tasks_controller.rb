class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # Skip CSRF protection for API endpoints
  skip_before_action :verify_authenticity_token

  def index
    @status_filter = params[:status]

    @tasks = if @status_filter.present? && %w[open in_progress done overdue].include?(@status_filter)
               current_user.tasks.order(due_date: :asc).select { |t| t.display_status == @status_filter }
             else
               current_user.tasks.order(due_date: :asc)
             end

    tasks_json = @tasks.map do |task|
      task.as_json(only: [:id, :title, :description, :due_date, :priority]).merge(
        status: task.display_status
      )
    end

    render json: tasks_json
  end

  def show
    task_data = @task.as_json(
      only: [:id, :title, :description, :due_date, :priority],
      include: {
        subtasks: { only: [:id, :title, :completed] } # included 'completed' if you need checkbox state
      }
    )

    task_data[:status] = @task.display_status
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
    params.require(:task).permit(
      :title,
      :description,
      :assignee_id,
      :due_date,
      :status,
      :priority,
      attachments: [],
      subtasks_attributes: [:id, :title, :completed, :_destroy]
    )
  end
end

class Task < ApplicationRecord
  VALID_PRIORITIES = %w[low medium high].freeze

  belongs_to :user
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :subtasks, dependent: :destroy
  has_many_attached :attachments

  validates :title, presence: true
  validates :priority, presence: true, inclusion: { in: VALID_PRIORITIES }

  # Add any additional validations or methods here
end
