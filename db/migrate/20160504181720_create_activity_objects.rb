class CreateActivityObjects < ActiveRecord::Migration
  def change
    create_table :activity_objects do |t|
      t.string :name
      t.references :locale, index: true

      t.timestamps
    end
  end
end
