class AddFieldsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :duration, :integer
    add_column :projects, :progress, :float
    add_column :projects, :sortorder, :integer
    add_column :projects, :parent, :integer
  end
end
