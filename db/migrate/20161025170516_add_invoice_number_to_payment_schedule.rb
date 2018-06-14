class AddInvoiceNumberToPaymentSchedule < ActiveRecord::Migration
  def change
    add_column :payment_schedules, :invoice_number, :integer
  end
end
