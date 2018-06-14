class AddIsSetUpToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :is_setup, :boolean, :default => false
  end
end
