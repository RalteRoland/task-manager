class AddRoleIdToUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.text :description
      t.timestamps
    end

    add_index :roles, :name, unique: true

    # Add role_id to users
    add_reference :users, :role, null: true, foreign_key: true
  end
end
