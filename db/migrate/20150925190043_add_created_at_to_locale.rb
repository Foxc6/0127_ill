class AddCreatedAtToLocale < ActiveRecord::Migration
  def change
    add_column :locales, :created_at, :datetime
    add_column :locales, :updated_at, :datetime
  end
end
