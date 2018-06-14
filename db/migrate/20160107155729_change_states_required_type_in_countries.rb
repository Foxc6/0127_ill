class ChangeStatesRequiredTypeInCountries < ActiveRecord::Migration
  def change
    change_column :countries, :states_required, :boolean
  end
end
