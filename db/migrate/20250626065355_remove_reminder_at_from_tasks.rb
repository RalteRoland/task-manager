class RemoveReminderAtFromTasks < ActiveRecord::Migration[8.0]
  def change
    remove_column :tasks, :reminder_at, :datetime
  end
end
