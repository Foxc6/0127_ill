class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.string :to
      t.text :body
      t.string :message_type
      t.string :template

      t.timestamps
    end
  end
end
