class CreateInfluenceManagers < ActiveRecord::Migration
  def change
    create_table :influence_managers do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :email
      t.string :phone
      t.string :address
      t.string :city
      t.string :zip
      t.text :note

      t.timestamps
    end
  end
end
