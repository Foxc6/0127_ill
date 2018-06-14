class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :iso_name
      t.string :iso
      t.string :iso3
      t.string :name
      t.integer :numcode
      t.integer :states_required, :limit => 1

      t.timestamps
    end
  end
end
