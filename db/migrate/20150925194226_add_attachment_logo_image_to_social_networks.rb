class AddAttachmentLogoImageToSocialNetworks < ActiveRecord::Migration
  def self.up
    change_table :social_networks do |t|
      t.attachment :logo_image
    end
  end

  def self.down
    remove_attachment :social_networks, :logo_image
  end
end
