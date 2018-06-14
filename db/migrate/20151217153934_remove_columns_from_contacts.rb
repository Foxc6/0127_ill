class RemoveColumnsFromContacts < ActiveRecord::Migration
  def change
    remove_column :contacts, :phone, :string
    remove_column :contacts, :address, :string
    remove_column :contacts, :city, :string
    remove_column :contacts, :zip, :string
  end
end
