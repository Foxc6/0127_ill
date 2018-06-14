class ChangeAmountInPaymentLineItems < ActiveRecord::Migration
  def change
    change_column :payment_line_items, :amount, :decimal, :precision => 10, :scale => 2, :default => 0.00
    change_column :payment_schedules, :total, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end

end
