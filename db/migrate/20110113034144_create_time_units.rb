class CreateTimeUnits < ActiveRecord::Migration
  def self.up
    create_table :time_units do |t|
      t.string :name
      t.timestamps
    end

    add_index :time_units, :name, :unique => true
  end

  def self.down
    drop_table :time_units
    remove_index :time_units, :name
  end
end
