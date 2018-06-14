class CreateContactSkills < ActiveRecord::Migration
  def change
    create_table :contact_skills do |t|
      t.string :name
      t.references :contact, index: :true

      t.timestamps
    end
  end
end
