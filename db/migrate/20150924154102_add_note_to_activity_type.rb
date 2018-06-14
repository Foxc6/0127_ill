class AddNoteToActivityType < ActiveRecord::Migration
  def change
    add_column :activity_types, :note, :text
  end
end
