class AddAttachmentIconImageToActivityTypes < ActiveRecord::Migration
  def self.up
    change_table :activity_types do |t|
      t.attachment :icon_image
    end
  end

  def self.down
    remove_attachment :activity_types, :icon_image
  end
end
