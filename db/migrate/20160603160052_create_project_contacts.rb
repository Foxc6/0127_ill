class CreateProjectContacts < ActiveRecord::Migration
  def change
    create_table :project_contacts do |t|
      t.string :name
      t.references :contact, index: true
      t.references :project, index: true

      t.timestamps
    end
  end
end
