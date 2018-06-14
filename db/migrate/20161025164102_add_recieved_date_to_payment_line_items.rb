class AddRecievedDateToPaymentLineItems < ActiveRecord::Migration
  def change
    add_column :payment_line_items, :recieved_date, :datetime
  end
end
