class AddAdminIdToLocales < ActiveRecord::Migration
   def change
    change_table :locales do |t|
      t.references :admin, index: true
    end
  end
  def down
    change_table :locales do |t|
      t.remove :admin_id
    end
  end
end
