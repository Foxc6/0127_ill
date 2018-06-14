class AddAttachmentProfileImageToInfluencers < ActiveRecord::Migration
  def self.up
    change_table :influencers do |t|
      t.attachment :profile_image
    end
  end

  def self.down
    remove_attachment :influencers, :profile_image
  end
end
