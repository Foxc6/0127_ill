class AddScoreToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :score, :float, default: 0
  end
end
