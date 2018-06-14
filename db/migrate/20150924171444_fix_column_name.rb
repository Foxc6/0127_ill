class FixColumnName < ActiveRecord::Migration
  def change
    change_table :locales do |t|
      t.rename :twiiter_link, :twitter_link
    end
  end
end
