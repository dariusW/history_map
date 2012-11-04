class AddDefaultValueToUsersPermissions < ActiveRecord::Migration
  def change
    change_column :users, :permissions, :boolean, default: false
  end
end
