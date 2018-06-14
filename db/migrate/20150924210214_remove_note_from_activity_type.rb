class RemoveNoteFromActivityType < ActiveRecord::Migration
  def change
    remove_column :activity_types, :note, :text
  end
end
