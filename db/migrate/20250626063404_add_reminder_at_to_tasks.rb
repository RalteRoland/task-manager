class AddReminderAtToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :reminder_at, :datetime
  end
end
