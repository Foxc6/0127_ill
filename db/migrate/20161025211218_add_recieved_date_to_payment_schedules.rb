class AddRecievedDateToPaymentSchedules < ActiveRecord::Migration
  def change
    add_column :payment_schedules, :received_date, :datetime
  end
end
