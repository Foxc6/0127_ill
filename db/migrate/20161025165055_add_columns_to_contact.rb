class AddColumnsToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :project_value, :decimal, :precision => 10, :scale => 2, :default => 0.00
    add_column :contacts, :total_value, :decimal, :precision => 10, :scale => 2, :default => 0.00
    add_column :contacts, :referral_value, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end
end
