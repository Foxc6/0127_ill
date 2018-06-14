class RenameOrderInEstimateLineItems < ActiveRecord::Migration
  def change
  	rename_column :estimate_line_items, :order, :position
  end
end
