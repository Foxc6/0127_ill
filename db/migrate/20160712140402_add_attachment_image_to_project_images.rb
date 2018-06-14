class AddAttachmentImageToProjectImages < ActiveRecord::Migration
  def self.up
    change_table :project_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :project_images, :image
  end
end
