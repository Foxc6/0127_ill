class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email
      t.references :contact, index: true

      t.timestamps
    end
  end
end
