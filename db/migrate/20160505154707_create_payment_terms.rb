class CreatePaymentTerms < ActiveRecord::Migration
  def change
    create_table :payment_terms do |t|
      t.string :type
      t.references :payment_schedule, index: :true

      t.timestamps
    end
  end
end
