class AddVersioning < ActiveRecord::Migration
  def self.up
    Contract.create_versioned_table
    Timesheet.create_versioned_table
  end

  def self.down
    Contract.drop_versioned_table
    Timesheet.drop_versioned_table
  end
end
