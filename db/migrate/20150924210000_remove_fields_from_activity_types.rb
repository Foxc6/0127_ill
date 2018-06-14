class RemoveFieldsFromActivityTypes < ActiveRecord::Migration
  def change
    remove_column :activity_types, :social, :boolean
    remove_column :activity_types, :package, :boolean
    remove_column :activity_types, :email, :boolean
    remove_column :activity_types, :phone_meeting, :boolean
    remove_column :activity_types, :in_person_meeting, :boolean
    remove_column :activity_types, :paid_campaign, :boolean
    remove_column :activity_types, :event, :boolean
  end
end
