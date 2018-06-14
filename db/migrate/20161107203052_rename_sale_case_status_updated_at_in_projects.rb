class RenameSaleCaseStatusUpdatedAtInProjects < ActiveRecord::Migration
  def change
  	rename_column :projects, :sale_case_status_updated_at, :status_updated_at
  end
end
