class FixTasksStatusColumn < ActiveRecord::Migration[7.1]
  def up
    # Delete old string column (if you’re using only status_id from now on)
    remove_column :tasks, :status, :string if column_exists?(:tasks, :status)

    # Get ID of 'open' status
    open_status_id = Status.find_by(name: 'open')&.id
    raise "Default status 'open' not found in statuses table" unless open_status_id

    # Set all nulls to 'open'
    Task.where(status_id: nil).update_all(status_id: open_status_id)

    # Set default for future tasks
    change_column_default :tasks, :status_id, from: nil, to: open_status_id

    # Enforce NOT NULL
    change_column_null :tasks, :status_id, false
  end

  def down
    add_column :tasks, :status, :string unless column_exists?(:tasks, :status)
    change_column_null :tasks, :status_id, true
    change_column_default :tasks, :status_id, nil
  end
end
