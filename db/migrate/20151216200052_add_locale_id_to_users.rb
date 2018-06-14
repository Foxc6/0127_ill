class AddLocaleIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :locale, index: true
  end
end
