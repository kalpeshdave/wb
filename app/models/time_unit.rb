class TimeUnit < ActiveRecord::Base
  has_many :timesheet_defaults
  has_many :timesheets
  belongs_to :time_base

  NAMES = find(:all, :order => :name).map do |t|
    [t.name, t.id]
  end
end
