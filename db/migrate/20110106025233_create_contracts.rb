class CreateContracts < ActiveRecord::Migration
  def self.up
    create_table :contracts do |t|
      t.integer   :parent_id
      t.integer   :created_by, :null => false
      t.integer   :client_id
      t.integer   :recepient_id
      t.integer   :client_company_id
      t.integer   :recepient_company_id
      t.integer   :contract_type_id, :null => false
      t.integer   :last_contract_number
      t.string    :contract_number
      t.text      :description
      t.string    :status, :null => false
      t.text      :long_description
      t.date      :start_date
      t.date      :end_date
      t.boolean   :hide, :default => false
      t.boolean   :is_template, :default => false
      t.boolean   :is_recipient, :default => false
      t.boolean   :require_expenses_signature, :default => false
      t.boolean   :require_timesheets_signature, :default => false
      t.boolean   :allow_timesheets, :default => false
      t.boolean   :allow_expenses, :default => false
      t.string    :country
      t.string    :state
      t.string    :city
      t.integer   :payment_term_id
      t.decimal   :rate, :precision => 10, :scale => 2, :default => 0.00
      t.integer   :unit_quality, :default => 0
      t.integer   :currency_id
      t.timestamps
    end

    add_index :contracts, :client_id
  end

  def self.down
    drop_table :contracts
  end
end
