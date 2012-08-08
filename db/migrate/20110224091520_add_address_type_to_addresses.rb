class AddAddressTypeToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :is_primary, :boolean, :default => false
    add_column :addresses, :is_mailing, :boolean, :default => false
    add_column :addresses, :is_billing, :boolean, :default => false
  end

  def self.down
    remove_column :addresses, :is_primary
    remove_column :addresses, :is_mailing
    remove_column :addresses, :is_billing
  end
end
