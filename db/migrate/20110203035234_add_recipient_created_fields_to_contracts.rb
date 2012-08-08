class AddRecipientCreatedFieldsToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :recepient_client, :string
    add_column :contracts, :recepient_company, :string
  end

  def self.down
    remove_column(:contracts, :recepient_client)
    remove_column(:contracts, :recepient_company)
  end
end
