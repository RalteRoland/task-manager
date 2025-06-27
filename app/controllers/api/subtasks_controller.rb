class Api::SubtasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    subtask = Subtask.find(params[:id])
    if subtask.update(subtask_params)
      render json: subtask
    else
      render json: { errors: subtask.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def subtask_params
    params.require(:subtask).permit(:title, :completed)
  end

end
