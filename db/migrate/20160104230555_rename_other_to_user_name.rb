class RenameOtherToUserName < ActiveRecord::Migration
  def change
    change_column :social_reaches, :other, :string
  end
end
