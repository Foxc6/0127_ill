class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.integer :company_id
      t.integer :client_id
      t.datetime :datetime
      t.integer :number
      t.float :total
      t.timestamps
    end
  end
end
