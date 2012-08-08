class CreateTimesheetOptions < ActiveRecord::Migration
  def self.up
    create_table :timesheet_options do |t|
      t.integer :contract_id
      t.integer :user_id
      t.string  :visibility
      t.timestamps
    end
  end

  def self.down
    drop_table :timesheet_options
  end
end
