class AddSaleCaseIdToProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :sale_case_status, index: true
  end
end
