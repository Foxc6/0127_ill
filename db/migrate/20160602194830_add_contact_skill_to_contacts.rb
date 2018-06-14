class AddContactSkillToContacts < ActiveRecord::Migration
  def change
  	add_column :contacts, :contact_skill, :string
  end
end
