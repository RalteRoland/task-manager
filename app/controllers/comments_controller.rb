class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    comment = current_user.comments.new(comment_params)

    if comment.save
      # Promote task status from 'open' to 'in_progress' if needed
      task = comment.task
      if task.status == 'open'
        task.update(status: 'in_progress')
      end

      render json: comment, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :task_id)
  end
end
