class AddAttachmentLogoToPreferences < ActiveRecord::Migration
  def self.up
    change_table :preferences do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :preferences, :logo
  end
end
