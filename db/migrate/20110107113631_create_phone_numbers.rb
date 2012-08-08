class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.integer     :user_id,       :null => false
      t.string      :number,        :null => false
      t.string      :contact_type,  :null => false
      t.timestamps
    end

    add_index :phone_numbers, :user_id
    add_index :phone_numbers, :number
  end

  def self.down
    remove_index :phone_numbers, :user_id
    remove_index :phone_numbers, :number
    drop_table :phone_numbers
  end
end
