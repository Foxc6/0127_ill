class RemoveCaseIdFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :case_id, :integer
  end
end
