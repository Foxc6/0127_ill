class RenameInfluencers < ActiveRecord::Migration
  def change
    rename_table :influencers, :contacts
  end
end
