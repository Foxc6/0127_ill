class RenameRecievedDateInPaymentSchedules < ActiveRecord::Migration
  def change
    rename_column :payment_schedules, :recieved_date, :received_date
  end
end
