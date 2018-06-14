class AddInvisibleToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :invisible, :boolean, default: false
  end
end
