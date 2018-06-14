class AddFieldsToSocialNetworks < ActiveRecord::Migration
  def change
    add_column :social_networks, :name, :string
    add_column :social_networks, :api_key, :string
    add_column :social_networks, :api_secret, :string
  end
end
