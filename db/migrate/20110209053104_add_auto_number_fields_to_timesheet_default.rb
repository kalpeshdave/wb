class AddAutoNumberFieldsToTimesheetDefault < ActiveRecord::Migration
  def self.up
      add_column :timesheet_defaults, :auto_number, :boolean, :default => false, :null => false
      add_column :timesheet_defaults, :last_timesheet_number, :string
      add_column :timesheet_defaults, :timesheet_prefix, :string
  end

  def self.down
    remove_column :timesheet_defaults, :auto_number
    remove_column :timesheet_defaults, :last_timesheet_number
    remove_column :timesheet_defaults, :timesheet_prefix
  end
end
