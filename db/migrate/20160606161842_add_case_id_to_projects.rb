class AddCaseIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :case_id, :integer
  end
end
