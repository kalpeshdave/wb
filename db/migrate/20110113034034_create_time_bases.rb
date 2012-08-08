class CreateTimeBases < ActiveRecord::Migration
  def self.up
    create_table :time_bases do |t|
      t.string :name
      t.timestamps
    end

    add_index :time_bases, :name, :unique => true
  end

  def self.down
    drop_table :time_bases
    remove_index :time_bases, :name
  end
end
