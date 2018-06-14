class AddFieldsToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :default_country_code, :integer
    add_column :preferences, :is_domestic, :boolean, :default => true
  end
end
