class CreateSaleCaseStatuses < ActiveRecord::Migration
  def change
    create_table :sale_case_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
