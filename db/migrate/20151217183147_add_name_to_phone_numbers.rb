class AddNameToPhoneNumbers < ActiveRecord::Migration
  def change
    add_column :phone_numbers, :name, :string
    add_column :addresses, :name, :string
  end
end
