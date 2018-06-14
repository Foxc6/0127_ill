class RemoveClientFromPaymentSchedules < ActiveRecord::Migration
  def change
  	remove_reference :payment_schedules, :client, index: true
  end
end
