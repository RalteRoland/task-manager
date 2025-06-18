class UpdatePendingTasksToInProgress < ActiveRecord::Migration[7.0]
  def up
    Task.where(status: 'pending').update_all(status: 'in_progress')
  end

  def down
    Task.where(status: 'in_progress').update_all(status: 'pending')
  end
end
