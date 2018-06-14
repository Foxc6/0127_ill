class RenameAdminidToUserId < ActiveRecord::Migration
  def change
    rename_column :activities, :admin_id, :user_id
    rename_index :activities, :index_activities_on_admin_id, :index_activities_on_user_id
  end
end
