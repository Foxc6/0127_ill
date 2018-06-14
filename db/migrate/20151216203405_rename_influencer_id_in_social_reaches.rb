class RenameInfluencerIdInSocialReaches < ActiveRecord::Migration
  def change
   rename_column :social_reaches, :influencer_id, :contact_id
   rename_index :social_reaches, :index_social_reaches_on_influencer_id, :index_social_reaches_on_contact_id
  end
end
