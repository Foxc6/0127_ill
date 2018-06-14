class CreateTaskTypes < ActiveRecord::Migration
  def change
    create_table :task_types do |t|
      t.string :name
      t.attachment :icon_image

      t.timestamps
    end
  end
end
