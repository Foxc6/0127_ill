class RemoveBodyTitleFromPreference < ActiveRecord::Migration
  def change
    remove_column :preferences, :body_title, :string
  end
end
