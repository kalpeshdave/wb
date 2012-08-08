class CreatePaymentTerms < ActiveRecord::Migration
  def self.up
    create_table :payment_terms do |t|
      t.string  :name
      t.timestamps
    end
  end

  def self.down
    drop_table :payment_terms
  end
end
