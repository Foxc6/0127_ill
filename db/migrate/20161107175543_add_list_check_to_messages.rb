class AddListCheckToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :list_check, :text
  end
end
