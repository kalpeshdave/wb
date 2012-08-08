class TimesheetDefault < ActiveRecord::Base
  belongs_to :time_unit
  belongs_to :time_base

  belongs_to :timeable, :polymorphic => true

  validates_length_of :timesheet_prefix, :maximum => 14, :allow_nil => true, :allow_blank => true
  validates_length_of :last_timesheet_number, :maximum => 14, :allow_nil => true, :allow_blank => true

  validate :timesheet_number

  def timesheet_number
    case options
    when "autonumber"
      timesheet_number = timesheet_prefix.to_s + last_timesheet_number.to_s
      errors.add_to_base("Timesheet Prefix and Last Timesheet Number can't be more than 16 characters.") if timesheet_number.length > 16
    end
  end
  
end
