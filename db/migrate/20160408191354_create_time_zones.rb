class CreateTimeZones < ActiveRecord::Migration
  def change
    create_table :time_zones do |t|
      t.decimal :offset
      t.string :name

      t.timestamps
    end
  end
end
