class AddCompletedToSubtasks < ActiveRecord::Migration[8.0]
  def change
    add_column :subtasks, :completed, :boolean
  end
end
