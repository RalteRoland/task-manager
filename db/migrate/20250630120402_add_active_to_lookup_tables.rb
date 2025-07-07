class AddActiveToLookupTables < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :active, :boolean, default: true
    add_column :priorities, :active, :boolean, default: true
    add_column :roles, :active, :boolean, default: true
  end
end
