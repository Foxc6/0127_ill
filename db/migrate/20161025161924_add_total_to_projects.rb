class AddTotalToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :total, :decimal, :precision => 10, :scale => 2, :default => 0.00
    add_column :projects, :estimated_total, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end
end
