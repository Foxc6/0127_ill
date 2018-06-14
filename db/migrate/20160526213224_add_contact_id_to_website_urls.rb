class AddContactIdToWebsiteUrls < ActiveRecord::Migration
  def change
  	add_reference :website_urls, :contact, index: true
  end
end
