class Api::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.includes(:assigned_tasks).map do |user|
      {
        id: user.id,
        name: user.name,
        role: user.role || "N/A",
        assigned_tasks_count: user.assigned_tasks.count,
        status: "Active" ,


      }
    end

    render json: users
  end
end
