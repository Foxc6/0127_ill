class ChangePaymentTermTypeToName < ActiveRecord::Migration
  def change
    rename_column :payment_terms, :type, :name
  end
end
