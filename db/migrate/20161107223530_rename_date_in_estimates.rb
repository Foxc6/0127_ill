class RenameDateInEstimates < ActiveRecord::Migration
  def change
    rename_column :estimates, :datetime, :date
  end
end
