class DropRolesAndUserRoles < ActiveRecord::Migration[7.0]
  def change
    drop_table :user_roles
    drop_table :roles
  end
end
