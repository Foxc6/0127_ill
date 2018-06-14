class AddDatesToLocalesTable < ActiveRecord::Migration
  def change
    add_column :locales, :start_date, :datetime
    add_column :locales, :end_date, :datetime
  end
end
