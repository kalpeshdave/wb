class TimeBase < ActiveRecord::Base
  has_many :timesheet_defaults
  has_many :timesheets
  has_many :time_units
  
  NAMES = self.find(:all, :order => :name).map do |t|
    [t.name, t.id]
  end
end
