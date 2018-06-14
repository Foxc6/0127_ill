class AddInfluencerToSocialReach < ActiveRecord::Migration
  def change
    add_reference :social_reaches, :influencer, index: true
  end
end
