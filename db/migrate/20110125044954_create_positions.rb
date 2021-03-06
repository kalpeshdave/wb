class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.references     :positionable
      t.string         :positionable_type
      t.string  :name
      t.timestamps
    end
  end

  def self.down
    drop_table :positions
  end
end
