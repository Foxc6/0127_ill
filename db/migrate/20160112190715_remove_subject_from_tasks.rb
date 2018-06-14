class RemoveSubjectFromTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :subject, :string
  end
end
