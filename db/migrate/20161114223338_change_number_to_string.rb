class ChangeNumberToString < ActiveRecord::Migration
  def change
    change_column :estimates, :number, :string
  end
end
