class CreateContractTypes < ActiveRecord::Migration
  def self.up
    create_table :contract_types do |t|
      t.string  :name
      t.timestamps
    end
    
    add_index :contract_types, :name, :unique => true
  end

  def self.down
    drop_table :contract_types
  end
end
