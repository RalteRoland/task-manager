class AllowNullOnPriorityIdInTasks < ActiveRecord::Migration[7.1]
  def up
    change_column_null :tasks, :priority_id, true
  end

  def down
    change_column_null :tasks, :priority_id, false
  end
end
