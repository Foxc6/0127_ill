class AddLocaleIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :locale_id, :integer
  end
end
