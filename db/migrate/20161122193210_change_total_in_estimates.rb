class ChangeTotalInEstimates < ActiveRecord::Migration
  def change
  	change_column :estimates, :total, :decimal, :precision => 14, :scale => 2
  end
end
