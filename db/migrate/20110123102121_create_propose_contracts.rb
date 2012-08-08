class CreateProposeContracts < ActiveRecord::Migration
  def self.up
    create_table :propose_contracts do |t|
      t.integer :contract_id, :null => false
      t.string  :recipient_id
      t.string  :recipient
      t.string  :description
      t.text    :message
      t.timestamps
    end

    add_index :propose_contracts, :contract_id
  end

  def self.down
    remove_index :propose_contracts, :contract_id
    drop_table :propose_contracts
  end
end
