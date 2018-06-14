class ChangeColoumnValuesInTask < ActiveRecord::Migration
  def change
    rename_column :tasks, :start_date, :started_at
    remove_column :tasks, :end_date
  end
end
