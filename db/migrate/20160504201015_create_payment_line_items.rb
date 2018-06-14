class CreatePaymentLineItems < ActiveRecord::Migration
  def change
    create_table :payment_line_items do |t|
      t.references :payment_schedule, index: :true
      t.decimal :amount
      t.string :description

      t.timestamps
    end
  end
end
