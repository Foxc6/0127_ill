class CreatePaymentSchedules < ActiveRecord::Migration
  def change
    create_table :payment_schedules do |t|
      t.references :client, index: :true
    	t.references :project, index: :true
    	t.string :description
    	t.references :payment_term, index: :true
    	t.datetime :invoice_date
    	t.integer :total
    	t.integer :duration
    	t.references :payment_status, index: :true

      t.timestamps
    end
  end
end
