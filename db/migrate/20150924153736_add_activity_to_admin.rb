class AddActivityToAdmin < ActiveRecord::Migration
  def change
    add_reference :admins, :activity, index: true
  end
end
