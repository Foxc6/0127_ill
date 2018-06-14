class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :postal_code
      t.string :state_name
      t.string :country_name
      t.integer :state_id
      t.integer :country_id

      t.timestamps
    end
  end
end
