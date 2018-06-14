class CreateSaleContacts < ActiveRecord::Migration
  def change
    create_table :sale_contacts do |t|
      t.references :contact, index: :true
      t.references :project, index: :true

      t.timestamps
    end
  end
end
