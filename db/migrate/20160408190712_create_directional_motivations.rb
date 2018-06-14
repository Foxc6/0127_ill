class CreateDirectionalMotivations < ActiveRecord::Migration
  def change
    create_table :directional_motivations do |t|
      t.string :name

      t.timestamps
    end
  end
end
