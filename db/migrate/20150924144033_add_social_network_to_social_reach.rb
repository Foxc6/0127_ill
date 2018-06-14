class AddSocialNetworkToSocialReach < ActiveRecord::Migration
  def change
    add_reference :social_reaches, :social_network, index: true
  end
end
