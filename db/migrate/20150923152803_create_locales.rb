class CreateLocales < ActiveRecord::Migration
  def change
    create_table :locales do |t|
      t.string :code
      t.integer :submission_count, :default => 0
      t.string :fb_locale
      t.string :fb_page
      t.string :fb_page_id
      t.string :find_store_link
      t.string :shop_now_link
      t.string :privacy_link
      t.string :terms_link
      t.string :video_link
      t.string :redirect_link
      t.string :logo_link
      t.boolean :is_not_participating, default: false
      t.boolean :active, default: false
      t.boolean :isAPAC, default: false
      t.string :tracking_code
      t.string :tracking_domain
      t.string :twiiter_link
      t.string :name
    end
  end
end
