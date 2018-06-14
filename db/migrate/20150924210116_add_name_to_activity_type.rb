class AddNameToActivityType < ActiveRecord::Migration
  def change
    add_column :activity_types, :name, :string
  end
end
