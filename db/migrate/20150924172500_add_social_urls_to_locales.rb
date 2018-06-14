class AddSocialUrlsToLocales < ActiveRecord::Migration
  def change
    add_column :locales, :facebook_url, :string
    add_column :locales, :twitter_url, :string
    add_column :locales, :youtube_url, :string
    add_column :locales, :pinterest_url, :string
    add_column :locales, :instagram_url, :string
  end
end
