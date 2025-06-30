class FixTasksPriorityColumn < ActiveRecord::Migration[7.1]
  def up
    # Remove old string column if it exists
    remove_column :tasks, :priority, :string if column_exists?(:tasks, :priority)

    # Create priorities if they don't exist
    create_priorities_if_missing

    # Get ID of 'medium' priority
    medium_priority_id = Priority.find_by(name: 'medium')&.id
    raise "Default priority 'medium' not found in priorities table" unless medium_priority_id

    # Set all nulls to 'medium'
    Task.where(priority_id: nil).update_all(priority_id: medium_priority_id)

    # Set default for new tasks
    change_column_default :tasks, :priority_id, from: nil, to: medium_priority_id

    # Enforce NOT NULL
    change_column_null :tasks, :priority_id, false
  end

  def down
    add_column :tasks, :priority, :string unless column_exists?(:tasks, :priority)
    change_column_null :tasks, :priority_id, true
    change_column_default :tasks, :priority_id, nil
  end

  private

  def create_priorities_if_missing
    # Create priorities if they don't exist
    ['low', 'medium', 'high'].each do |priority_name|
      Priority.find_or_create_by(name: priority_name) do |priority|
        priority.created_at = Time.current
        priority.updated_at = Time.current
      end
    end
  end
end
