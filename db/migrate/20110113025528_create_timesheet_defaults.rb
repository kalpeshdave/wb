class CreateTimesheetDefaults < ActiveRecord::Migration
  def self.up
    create_table :timesheet_defaults do |t|
      t.integer :time_base_id
      t.integer :time_unit_id
      t.decimal :default_value, :precision => 10, :scale => 2, :default => 0.00
      t.string  :timeable_type, :null => false
      t.string  :timeable_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :timesheet_defaults
  end
end
