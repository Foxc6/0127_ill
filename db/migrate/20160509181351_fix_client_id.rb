class FixClientId < ActiveRecord::Migration
  def change
  	change_table :projects do |t|
    	t.rename :client_id, :client_contact_id
    end
  end
end
