class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true
      t.references :contact, index: true
      t.references :task_type, index: true
      t.timestamp :completed_at

      t.timestamps
    end
  end
end
