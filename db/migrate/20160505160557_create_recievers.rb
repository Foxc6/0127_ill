class CreateRecievers < ActiveRecord::Migration
  def change
    create_table :recievers do |t|
      t.references :contact, index: :true
      t.references :payment_schedule, index: :true

      t.timestamps
    end
  end
end
