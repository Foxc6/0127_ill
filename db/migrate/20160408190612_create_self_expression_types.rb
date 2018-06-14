class CreateSelfExpressionTypes < ActiveRecord::Migration
  def change
    create_table :self_expression_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
