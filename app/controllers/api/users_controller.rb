class Api::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    users = User.includes(:assigned_tasks, :role).map do |user|
      {
        id: user.id,
        name: user.name,
        role: {
          name: user.role&.name || "N/A"    # ✅ wrap in object
        },
        assigned_tasks_count: user.assigned_tasks.count,
        status: user.active ? "Active" : "Inactive"
      }
    end

    render json: users
  end
end
