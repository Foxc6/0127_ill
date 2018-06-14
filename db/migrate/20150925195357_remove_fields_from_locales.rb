class RemoveFieldsFromLocales < ActiveRecord::Migration
  def change
    remove_column :locales, :submission_count, :integer
    remove_column :locales, :find_store_link, :string
    remove_column :locales, :shop_now_link, :string
    remove_column :locales, :privacy_link, :string
    remove_column :locales, :terms_link, :string
    remove_column :locales, :video_link, :string
    remove_column :locales, :is_not_participating, :boolean
    remove_column :locales, :admin_id, :integer
  end
end
