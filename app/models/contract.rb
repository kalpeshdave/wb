class Contract < ActiveRecord::Base
  acts_as_tree# :order => "name"
  include AASM

  # Plugin for Maintaining History
  acts_as_versioned

  attr_accessor :post_type
  
  belongs_to :contract_type
  belongs_to :client, :class_name => "User"
  belongs_to :creator, :class_name => "User", :foreign_key => :created_by
  has_one :subcontract, :class_name => "Contract", :foreign_key => :parent_id
  
  belongs_to :currency
  belongs_to :company, :foreign_key => :client_company_id
  belongs_to :recepient_company, :class_name => "Company", :foreign_key => :recepient_company_id
  belongs_to :recepient, :class_name => "User"
  has_many :timesheets
  
  PER_PAGE = 100

  has_one :propose_contract, :dependent => :destroy

  #has_one :parent, :class_name => 'User', :foreign_key => 'parent_id'
  has_one :contract_proposed
  
  has_many  :attachments, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :attachments

  has_many  :timesheet_options, :dependent => :destroy
#  accepts_nested_attributes_for :timesheet_options
  
  has_one :timesheet_default, :as => :timeable, :dependent => :destroy
  accepts_nested_attributes_for :timesheet_default

  has_one :invoice_default, :as => :invoiceable, :dependent => :destroy
  accepts_nested_attributes_for :invoice_default

  has_many :contract_histories, :dependent => :destroy

  named_scope :is_template, :conditions => {:is_template => true}

  
  named_scope :weekly_saved, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "saved", 7.days.ago, false]
  named_scope :weekly_posted, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "posted", 7.days.ago, false]
  named_scope :weekly_proposed, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "proposed", 7.days.ago, false]
  named_scope :weekly_sent, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "sent", 7.days.ago, false]
  named_scope :weekly_recieved, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "recieved", 7.days.ago, false]
  named_scope :weekly_rejected, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "rejected", 7.days.ago, false]
  named_scope :weekly_approved, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "approved", 7.days.ago, false]

  named_scope :monthly_saved, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "saved", 1.month.ago, false]
  named_scope :monthly_posted, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "posted", 1.month.ago, false]
  named_scope :monthly_proposed, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "proposed", 1.month.ago, false]
  named_scope :monthly_sent, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "sent", 1.month.ago, false]
  named_scope :monthly_recieved, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "recieved", 1.month.ago, false]
  named_scope :monthly_rejected, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "rejected", 1.month.ago, false]
  named_scope :monthly_approved, :conditions => ["status = ? AND created_at >= ? AND hide = ?", "approved", 1.month.ago, false]

  named_scope :recepient_contracts, lambda { |user_id|
    {
      :conditions => ["recepient_id = ? AND status = 'approved'", user_id],
      :order => "created_by DESC"
    }
  }
  named_scope :weekly_recepient_contracts, lambda { |user_id|
    {
      :conditions => ["recepient_id = ? AND status = ? AND created_at >= ?", user_id, 'approved', 7.days.ago],
      :order => "created_by DESC"
    }
  }
  named_scope :monthly_recepient_contracts, lambda { |user_id|
    {
      :conditions => ["recepient_id = ? AND status = ? AND created_at >= ?", user_id, 'approved', 1.month.ago],
      :order => "created_by DESC"
    }
  }

  named_scope :find_contract, lambda { |user_id|
    {
      :conditions => ["created_by = ? OR recepient_id = ?", user_id, user_id],
      :order => "created_by DESC"
    }
  }

  validates_presence_of :contract_number
  validates_length_of :contract_number, :maximum => 15, :allow_blank => true, :allow_nil => true
  validates_presence_of :description, :start_date, :end_date, :if => Proc.new { |i| i.post_type.eql?('Create Post') || i.post_type.eql?("Create & Propose") }
  validates_presence_of :recepient_company_id, :recepient_id, :if => Proc.new { |i| i.post_type.eql?('Create & Propose') || i.post_type.eql?('Update & Propose') }
  validate :check_dates, :unless => Proc.new{|u| u.attributes['start_date'].blank? && u.attributes['end_date'].blank?}

  def check_dates
    return if start_date.blank? || end_date.blank?
    errors.add_to_base("Begin date can not be after the End Date. It must be less than or equal to the End Date") if start_date > end_date
  end


  aasm_column :status

  aasm_initial_state :saved

  aasm_state :saved
  aasm_state :posted
  aasm_state :proposed

  # The below mentioned status is exctly not a status.. need to change the status...
  aasm_state :sent
  aasm_state :approved
  aasm_state :received
  aasm_state :rejected


#  aasm_event :incomplete do
#    transitions :to => :incomplete
#  end

  aasm_event :incomplete do
    transitions :to => :saved, :from => [:saved, :rejected, :posted]
  end

  aasm_event :post do
    transitions :to => :posted, :from => [:saved, :rejected]
  end
  
  aasm_event :propose do
    transitions :to => :proposed, :from => [:saved, :posted, :rejected]
  end

  aasm_event :sent do
    transitions :to => :sent
  end

  aasm_event :approved do
    transitions :to => :approved, :from => [:saved, :proposed]
  end

  aasm_event :received do
    transitions :to => :received
  end

  aasm_event :rejected do
    transitions :to => :rejected, :from => [:proposed]
  end

  def already_sub_contract_created?(user_id)
    return Contract.find(:first, :conditions => ["created_by = ? AND parent_id = ?", user_id, id]).blank?
  end


  def originator?(user)
    if self.created_by == user.id
      true
    else
      false
    end
  end

  def viewable?(user)
    if user
      if self.propose_contract && self.propose_contract.recipient_id.to_i.eql?(user.id)
        true
      elsif self.created_by == user.id
        true
      else
        false
      end
    end
  end

  

#  before_validation_on_create :generate_contract_number
  before_create :set_contract_type
  before_create :save_attachment
  before_create :update_status
  before_update :update_status
  before_create :contract_histroy
  before_update :contract_histroy
  after_create :update_contract_default

  def to_param
    "#{id}-#{contract_number}"
  end

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

  def has_subcontract?(current_user)
    contracts = Contract.find_contract(current_user.id)
    contracts.each do |c|
     if !c.parent_id.nil?
       true
     else
       false
     end
    end
  end
  

  private

  def contract_histroy
    self.contract_histories.build({ :user_id => self.created_by, :action => self.status })
  end

  def update_status
    case post_type
    when "Create & Post"
      post
    when "Update"
      incomplete
    end
  end

  def update_contract_default
    if self.contract_number.eql?(generate_contract_number[0])
      self.creator.contract_default.last_contract_number = generate_contract_number[1]
      self.creator.contract_default.save
    end
  end

  def generate_contract_number
    contract_default = ContractDefault.find_by_user_id(self.created_by)
    if contract_default.auto_number?
      if contract_default.last_contract_number.blank?
        number = 1
        current_contract_number = contract_default.contract_prefix + number.to_s
      else
        digits = contract_default.last_contract_number.split('').map(&:to_i)
        count = 0
        digits.each_with_index do |n,i|
          count = i-1
          break if !digits[i].zero?
        end
        unless count.eql?(-1)
          number = digits[0..count].join.to_s + (digits[count..digits.count].join.to_i + 1).to_s
          if number.length > contract_default.last_contract_number.length
            number.slice!(0)
          end
        else
          number = contract_default.last_contract_number.to_i + 1
        end
        current_contract_number = contract_default.contract_prefix.blank? ? number.to_s : contract_default.contract_prefix + number.to_s
      end     
    end
    [current_contract_number.to_s, number.to_s]
  end

  def set_contract_type
    self.contract_type_id = ContractType.find_by_name("Standard").id
  end
  
end
