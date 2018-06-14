class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :name
      t.string :company
      t.string :url
      t.text :meta_description
      t.text :meta_keywords
      t.string :seo_title
      t.string :mail_from_address
      t.boolean :default, default: false, null: false

      t.timestamps
    end
  end
end
