class RemoveContactIdFromContactTypes < ActiveRecord::Migration
  def change
    remove_reference :contact_types, :contact, index: true
  end
end
