class CreateContractHistories < ActiveRecord::Migration
  def self.up
    create_table :contract_histories do |t|
      t.integer :contract_id
      t.integer :user_id
      t.string :action
      t.timestamps
    end
  end

  def self.down
    drop_table :contract_histories
  end
end
