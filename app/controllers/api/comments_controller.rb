class Api::CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    task = Task.find(params[:task_id])
    per_page = (params[:per_page] || 10).to_i
    before_order = params[:before_order]&.to_i

    comments = task.comments
    comments = comments.where("comment_order < ?", before_order) if before_order
    comments = comments.order(comment_order: :desc).limit(per_page)

    render json: comments
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    head :no_content
  end


  def create
    Rails.logger.info "Current user: #{current_user&.email || 'Not authenticated'}"
    Rails.logger.info "Comment params: #{comment_params.inspect}"

    task = Task.find(comment_params[:task_id])

    # Get highest order so far, default to 0 if none exist
    last_order = task.comments.maximum(:comment_order) || 0

    # Create new comment with next order
    comment = current_user.comments.new(comment_params.merge(comment_order: last_order + 1))

    if comment.save
      Rails.logger.info "Comment saved. Task ID: #{task.id}, Current Status: #{task.status.name}"

      if task.status.name == 'open'
        in_progress_status = Status.find_by(name: 'in_progress')
        if in_progress_status
          success = task.update(status: in_progress_status)
          Rails.logger.info "Updating task ##{task.id} status to 'in_progress'..."
          Rails.logger.info "Status update success? #{success}"
        else
          Rails.logger.warn "Status 'in_progress' not found in the statuses table!"
        end
      end

      render json: comment, status: :created
    else
      Rails.logger.error "Failed to save comment: #{comment.errors.full_messages.join(', ')}"
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  rescue => e
    Rails.logger.error "Comment creation failed: #{e.message}"
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :task_id)
  end
end
