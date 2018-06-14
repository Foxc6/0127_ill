class AddLocaleIdToAdmin < ActiveRecord::Migration
  def change
    add_reference :admins, :locale, index: true
  end
end
