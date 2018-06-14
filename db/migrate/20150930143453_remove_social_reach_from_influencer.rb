class RemoveSocialReachFromInfluencer < ActiveRecord::Migration
  def change
    remove_reference :influencers, :social_reach, index: true
  end
end
