class CreateActivityTypes < ActiveRecord::Migration
  def change
    create_table :activity_types do |t|
      t.boolean :social
      t.boolean :package
      t.boolean :email
      t.boolean :phone_meeting
      t.boolean :in_person_meeting
      t.boolean :paid_campaign
      t.boolean :event

      t.timestamps
    end
  end
end
