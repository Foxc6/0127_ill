class AddScoreToProject < ActiveRecord::Migration
  def change
    add_column :projects, :score, :float, default: 0
  end
end
