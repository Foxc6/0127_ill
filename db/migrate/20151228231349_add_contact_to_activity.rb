class AddContactToActivity < ActiveRecord::Migration
  def change
  	add_reference :activities, :contact, index: true
  end
end