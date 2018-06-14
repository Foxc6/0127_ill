class AddOrderAndParentIdToEstimateLineItems < ActiveRecord::Migration
  def change
    add_column :estimate_line_items, :order, :integer
    add_column :estimate_line_items, :parent_id, :integer
  end
end
