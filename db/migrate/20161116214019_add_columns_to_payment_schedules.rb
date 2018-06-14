class AddColumnsToPaymentSchedules < ActiveRecord::Migration
  def change
    add_column :payment_schedules, :progress, :float
    add_column :payment_schedules, :sortorder, :integer
    add_column :payment_schedules, :parent, :integer
  end
end
