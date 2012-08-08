class CreateContractDefaults < ActiveRecord::Migration
  def self.up
    create_table :contract_defaults do |t|
      t.string  :user_id, :null => false
      t.boolean :allow_timesheet,             :default => false, :null => false
      t.boolean :allow_expenses,              :default => false, :null => false
      t.boolean :require_timesheet_signature, :default => false, :null => false
      t.boolean :require_expense_approval,    :default => false, :null => false
      t.boolean :auto_number,                 :default => false, :null => false
      t.string  :last_contract_number
      t.string  :contract_prefix
      t.timestamps
    end

    add_index :contract_defaults, :user_id, :unique => true
  end

  def self.down
    drop_table :contract_defaults
    add_index :contract_defaults, :user_id
  end
end
