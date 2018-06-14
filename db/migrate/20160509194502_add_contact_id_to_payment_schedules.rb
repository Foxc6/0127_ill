class AddContactIdToPaymentSchedules < ActiveRecord::Migration
  def change
  	add_reference :payment_schedules, :contact, index: true
  end
end
