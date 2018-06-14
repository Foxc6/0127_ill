class RenameOther < ActiveRecord::Migration
  def change
    rename_column :social_reaches, :other, :username
  end
end
