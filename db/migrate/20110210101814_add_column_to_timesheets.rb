class AddColumnToTimesheets < ActiveRecord::Migration
  def self.up
    add_column :timesheets, :time_base_id, :integer
    add_column :timesheets, :time_unit_id, :integer
  end

  def self.down
    remove_column :timesheets, :time_base_id
    remove_column :timesheets, :time_unit_id
  end
end
