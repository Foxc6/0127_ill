class FixColumnNameForSocialReaches < ActiveRecord::Migration
  def change
    change_table :social_reaches do |t|
      t.rename :blog_stats, :total_reach
    end
  end
end
