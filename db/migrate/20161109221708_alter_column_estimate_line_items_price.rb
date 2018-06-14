class AlterColumnEstimateLineItemsPrice < ActiveRecord::Migration
  def self.up
    change_table :estimate_line_items do |t|
      t.change :price, :decimal, :precision => 10, :scale => 2
    end
  end
  def self.down
    change_table :estimate_line_items do |t|
      t.change :price, :float
    end
  end
end