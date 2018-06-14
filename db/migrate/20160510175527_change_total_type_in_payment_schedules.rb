class ChangeTotalTypeInPaymentSchedules < ActiveRecord::Migration
  def change
    change_column :payment_schedules, :total, :decimal
  end
end
