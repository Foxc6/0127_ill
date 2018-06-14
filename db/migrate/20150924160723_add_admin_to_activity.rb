class AddAdminToActivity < ActiveRecord::Migration
  def change
    add_reference :activities, :admin, index: true
  end
end
