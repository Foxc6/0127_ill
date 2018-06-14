class AddBodyTitleToPreferences < ActiveRecord::Migration
  def change
    add_column :preferences, :body_title, :string
  end
end
