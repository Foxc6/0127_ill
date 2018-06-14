class RemoveListCheckFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :list_check, :text
  end
end
