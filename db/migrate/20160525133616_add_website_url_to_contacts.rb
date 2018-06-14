class AddWebsiteUrlToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :website_url, :string
  end
end
