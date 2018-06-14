class CreateWebsiteUrls < ActiveRecord::Migration
  def change
    create_table :website_urls do |t|
      t.string :url
      t.string :name
      t.references :contacts, index: :true


      t.timestamps
    end
  end
end
