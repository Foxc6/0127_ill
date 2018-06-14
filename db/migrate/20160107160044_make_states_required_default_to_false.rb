class MakeStatesRequiredDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :countries, :states_required, :boolean, :default => false
  end
end
