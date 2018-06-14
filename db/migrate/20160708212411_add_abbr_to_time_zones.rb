class AddAbbrToTimeZones < ActiveRecord::Migration
  def change
    add_column :time_zones, :abbr, :string
  end
end
