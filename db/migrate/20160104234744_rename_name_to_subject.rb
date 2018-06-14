class RenameNameToSubject < ActiveRecord::Migration
  def change
    rename_column :tasks, :name, :subject
  end
end
