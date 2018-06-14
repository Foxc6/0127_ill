class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.belongs_to :influence_manager, index: true
      t.text :note

      t.timestamps
    end
  end
end
