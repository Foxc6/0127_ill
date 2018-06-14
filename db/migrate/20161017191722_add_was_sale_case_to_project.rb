class AddWasSaleCaseToProject < ActiveRecord::Migration
  def change
    add_column :projects, :was_sale_case, :boolean
  end
end
