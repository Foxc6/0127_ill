class CreateEstimateLineItems < ActiveRecord::Migration
  def change
    create_table :estimate_line_items do |t|
      t.text :description
      t.float :price
      t.timestamps
    end
  end
end
