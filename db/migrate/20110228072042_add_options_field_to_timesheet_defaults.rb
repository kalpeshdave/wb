class AddOptionsFieldToTimesheetDefaults < ActiveRecord::Migration
  def self.up
    add_column :timesheet_defaults, :options, :string
    add_column :timesheet_defaults, :number_date_format1, :string
    add_column :timesheet_defaults, :number_date_format2, :string
  end

  def self.down
    remove_column :timesheet_defaults, :options
    remove_column :timesheet_defaults, :number_date_format1
    remove_column :timesheet_defaults, :number_date_format2
  end
end
