class CreateTimesheets < ActiveRecord::Migration
  def self.up
    create_table :timesheets do |t|
      t.integer   :parent_id
      t.integer   :created_by, :null => false
      t.integer   :contract_id
      t.integer   :last_contract_number
      t.string    :timesheet_number
      t.text      :contract_description
      t.text      :description
      t.string    :status, :null => false
      t.date      :start_date
      t.date      :end_date
      t.boolean   :hide, :default => false
      t.timestamps
    end

    add_index :timesheets, :contract_id
    add_index :timesheets, :last_contract_number
    add_index :timesheets, :timesheet_number
  end

  def self.down
    remove_index :timesheets, :contract_id
    remove_index :timesheets, :last_contract_number
    remove_index :timesheets, :timesheet_number
    drop_table :timesheets
  end
end
