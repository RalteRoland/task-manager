class AddPriorityToTasks < ActiveRecord::Migration[7.1]
  def change
    add_reference :tasks, :priority, foreign_key: true, null: true
  end
end
