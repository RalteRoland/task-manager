class AddReminderOptionToTasks < ActiveRecord::Migration[8.0]
  def change
    add_column :tasks, :reminder_option, :string
  end
end
