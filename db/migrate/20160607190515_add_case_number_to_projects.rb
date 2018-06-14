class AddCaseNumberToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :case_number, :string
  end
end
