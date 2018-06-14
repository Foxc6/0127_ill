class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :name
      t.references :project_state, index: :true
      t.references :client, index: :true
      t.references :project_type
      t.string :tags
      t.string :url
      t.string :project_number
      t.references :referral_contact
      t.references :sale_contact
      t.datetime :start_date
      t.datetime :end_date
      t.attachment :sow_file


      t.timestamps
    end
  end
end
