class AddTagNameToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :tag_name, :string
  end
end
