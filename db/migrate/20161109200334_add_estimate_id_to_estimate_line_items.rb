class AddEstimateIdToEstimateLineItems < ActiveRecord::Migration
  def change
    add_reference :estimate_line_items, :estimate, index: true
  end
end
