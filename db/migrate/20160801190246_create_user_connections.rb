class CreateUserConnections < ActiveRecord::Migration
  def change
    create_table :user_connections do |t|
      t.string :name
      t.integer :connector_id
      t.integer :connectie_id

      t.timestamps
    end
  end
end
