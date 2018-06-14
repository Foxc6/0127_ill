class RemoveContactsIdFromWebsiteUrls < ActiveRecord::Migration
  def change
  	remove_reference :website_urls, :contacts, index: true
  end
end
