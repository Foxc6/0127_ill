class AddSaleCaseStatusUpdatedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sale_case_status_updated_at, :datetime
  end
end
