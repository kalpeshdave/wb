class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.references     :addressable
      t.string         :addressable_type
      t.string         :address_type
      t.string         :address_description
      t.string         :address_1
      t.string         :address_2
      t.string         :city
      t.string         :zipcode
      t.string         :state
      t.string         :country
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
