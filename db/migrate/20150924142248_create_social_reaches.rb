class CreateSocialReaches < ActiveRecord::Migration
  def change
    create_table :social_reaches do |t|
      t.integer :blog_stats
      t.text :other

      t.timestamps
    end
  end
end
