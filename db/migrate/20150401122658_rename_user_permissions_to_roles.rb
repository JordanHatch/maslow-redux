class RenameUserPermissionsToRoles < ActiveRecord::Migration
  def change
    rename_column :users, :permissions, :roles
  end
end
