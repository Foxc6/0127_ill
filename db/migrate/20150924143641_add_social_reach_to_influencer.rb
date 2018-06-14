class AddSocialReachToInfluencer < ActiveRecord::Migration
  def change
    add_reference :influencers, :social_reach, index: true
  end
end
