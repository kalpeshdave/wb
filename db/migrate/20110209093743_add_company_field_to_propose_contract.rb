class AddCompanyFieldToProposeContract < ActiveRecord::Migration
  def self.up
    add_column :propose_contracts, :recipient_company, :string
    add_column :propose_contracts, :recipient_company_id, :integer
  end

  def self.down
    remove_column :propose_contracts, :recipient_company
    remove_column :propose_contracts, :recipient_company_id
  end
end
