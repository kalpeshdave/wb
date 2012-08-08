class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.references     :placable
      t.string         :placable_type
      t.string         :country
      t.string         :state
      t.string         :city
      
      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
