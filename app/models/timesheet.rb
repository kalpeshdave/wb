class Timesheet < ActiveRecord::Base
  include AASM
  attr_accessor :post_type
  PER_PAGE=100

  # Plugin for Maintaining History
  acts_as_versioned

  belongs_to :contract
  has_one :parent, :class_name => 'User', :foreign_key => 'parent_id'
  belongs_to :creator, :class_name => "User", :foreign_key => :created_by
  belongs_to :time_base
  belongs_to :time_unit

  validates_presence_of :contract_id, :if => Proc.new { |i| i.post_type.eql?("Create & Submit") }
  validates_presence_of :timesheet_number
  validates_presence_of :time_base
  validates_presence_of :time_unit
  validates_length_of :timesheet_number, :maximum => 16


  has_many  :attachments, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :attachments
  
  named_scope :weekly_incomplete, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "saved", 7.days.ago, false]
  named_scope :weekly_submitted, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "submitted", 7.days.ago, false]
  named_scope :weekly_received, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "received", 7.days.ago, false]
  named_scope :weekly_approved, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "approved", 7.days.ago, false]
  named_scope :weekly_rejected, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "rejected", 7.days.ago, false]
  
  named_scope :monthly_incomplete, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "saved", 1.month.ago, false]
  named_scope :monthly_submitted, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "submitted", 1.month.ago, false]
  named_scope :monthly_received, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "received", 1.month.ago, false]
  named_scope :monthly_approved, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "approved", 1.month.ago, false]
  named_scope :monthly_rejected, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "rejected", 1.month.ago, false]


  

  
#  before_validation_on_create :generate_timesheet_number
  before_create :save_attachment
  before_create :update_status
  before_update :update_status
  after_create :update_timesheet_default

  aasm_column :status

  aasm_initial_state :saved

  aasm_state :saved
  aasm_state :incomplete
  aasm_state :submitted
  aasm_state :received
  aasm_state :approved
  aasm_state :rejected

  aasm_event :saved do
    transitions :to => :saved
  end

  aasm_event :submit do
    transitions :to => :submitted, :from => [:saved, :incomplete, :saved]
  end

  aasm_event :approved do
    transitions :to => :approved, :from => [:submitted]
  end

  aasm_event :received do
    transitions :to => :received, :from => [:incompleted, :saved, :submitted]
  end

  aasm_event :rejected do
    transitions :to => :rejected, :from => [:submitted]
  end

#  def to_param
#    "#{id}-#{contract.contract_number}"
#  end
  
  def new_attachment_attributes=(attachment_attributes)
    attachment_attributes.each do |a|
      attachments.build(a)
    end
  end

  def existing_attachment_attributes=(attachment_attributes)
    attachments.reject(&:new_record?).each do |a|
      attributes = attachment_attributes[a.id.to_s]
      if attributes
        a.attributes = attributes
      else
        attachments.delete(a)
      end
    end
  end

  def save_attachment
    attachments.each { |a| a.save(false) }
  end

  def set_end_date(timebase)
    case timebase
      when "Day"
        Date.today+1
      when "Week"
        Date.today+7
      when "Month"
        Date.today+30
      when "Year"
        Date.today+365
      else
        Date.today
    end
  end

  def deliver_timesheet!
    UserNotifier.deliver_timesheet(self)
  end

  
  

  private

  def update_status
    case post_type
    when "Create & Submit" 
      submit
    when "Save & Submit"
       submit
    end
  end

  def update_timesheet_default
    if self.timesheet_number.eql?(generate_timesheet_number[0])
      self.creator.timesheet_default.last_timesheet_number = generate_timesheet_number[1]
      self.creator.timesheet_default.save
    end
  end

  def generate_timesheet_number
    user = User.find(self.created_by)
    timesheet_default = user.timesheet_default
    case timesheet_default.options
      when "autonumber"
        if timesheet_default.last_timesheet_number.blank?
          number = 1
          current_timesheet_number = timesheet_default.timesheet_prefix + number.to_s
        else
          digits = timesheet_default.last_timesheet_number.split('').map(&:to_i)
        count = 0
        digits.each_with_index do |n,i|
          count = i-1
          break if !digits[i].zero?
        end
        unless count.eql?(-1)
          number = digits[0..count].join.to_s + (digits[count..digits.count].join.to_i + 1).to_s
          if number.length > timesheet_default.last_timesheet_number.length
            number.slice!(0)
          end
        else
          number = timesheet_default.last_timesheet_number.to_i + 1
        end
          current_timesheet_number = timesheet_default.timesheet_prefix.blank? ? number : timesheet_default.timesheet_prefix + number.to_s
        end
      when "begindate"
        current_timesheet_number = self.start_date.to_s
      when "enddate"
        current_timesheet_number = self.end_date.to_s 
      when "begin+end"
        current_timesheet_number = self.start_date.to_s + self.end_date.to_s 
      when "begin+num1"
        if timesheet_default.last_timesheet_number.blank?
          number = 1
          current_timesheet_number = self.start_date.to_s + number.to_s
        else
          digits = timesheet_default.last_timesheet_number.split('').map(&:to_i)
        count = 0
        digits.each_with_index do |n,i|
          count = i-1
          break if !digits[i].zero?
        end
        unless count.eql?(-1)
          number = digits[0..count].join.to_s + (digits[count..digits.count].join.to_i + 1).to_s
          if number.length > timesheet_default.last_timesheet_number.length
            number.slice!(0)
          end
        else
          number = timesheet_default.last_timesheet_number.to_i + 1
        end
          current_timesheet_number = self.start_date.to_s + number.to_s
        end
      when "end+num2"
        if timesheet_default.last_timesheet_number.blank?
          number = 1
          current_timesheet_number = self.end_date.to_s + number.to_s
        else
          digits = timesheet_default.last_timesheet_number.split('').map(&:to_i)
        count = 0
        digits.each_with_index do |n,i|
          count = i-1
          break if !digits[i].zero?
        end
        unless count.eql?(-1)
          number = digits[0..count].join.to_s + (digits[count..digits.count].join.to_i + 1).to_s
          if number.length > timesheet_default.last_timesheet_number.length
            number.slice!(0)
          end
        else
          number = timesheet_default.last_timesheet_number.to_i + 1
        end
          current_timesheet_number = self.end_date.to_s + number.to_s
        end
      end
      [current_timesheet_number.to_s, number.to_s]
  end

 
  
end
