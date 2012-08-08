class CreateInvoiceDefaults < ActiveRecord::Migration
  def self.up
    create_table :invoice_defaults do |t|
      t.integer :invoiceable_id, :null => false
      t.string  :invoiceable_type, :null => false
      t.integer :payment_term_id
      t.integer :currency_id 
      t.decimal :rate, :precision => 5, :scale => 2, :default => 0.00
      t.decimal :unit_quantity, :precision => 5, :scale => 2, :default => 0.00
      t.timestamps
    end
  end

  def self.down
    drop_table :invoice_defaults
  end
end
