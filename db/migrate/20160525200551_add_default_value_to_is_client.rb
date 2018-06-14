class AddDefaultValueToIsClient < ActiveRecord::Migration
  def change
    change_column :contacts, :is_client, :boolean, :default => false
  end
end
