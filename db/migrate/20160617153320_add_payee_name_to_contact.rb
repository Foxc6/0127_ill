class AddPayeeNameToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :payee_name, :string
  end
end
