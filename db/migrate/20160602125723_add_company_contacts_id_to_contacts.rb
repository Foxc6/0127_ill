class AddCompanyContactsIdToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :company_contact_id, :integer
  end
end
