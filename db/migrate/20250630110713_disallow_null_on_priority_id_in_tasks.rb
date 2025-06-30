class DisallowNullOnPriorityIdInTasks < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tasks, :priority_id, false
  end
end
