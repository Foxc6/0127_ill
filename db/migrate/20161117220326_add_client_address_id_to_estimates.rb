class AddClientAddressIdToEstimates < ActiveRecord::Migration
  def change
  	add_reference :estimates, :client_address, references: :addresses
  end
end
