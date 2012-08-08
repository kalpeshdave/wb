class User < ActiveRecord::Base
 # attr_accessor :user_preference_attribtues
  attr_accessor :new_addresses_attributes

  has_one :user_preference, :dependent => :destroy
  accepts_nested_attributes_for :user_preference, :allow_destroy => true
  
  has_many :user_access_lists, :dependent => :destroy
  has_many :contract_proposeds, :dependent => :destroy
  has_many :attachments, :dependent => :destroy
  has_many :contract_histories, :dependent => :destroy
  
  has_many :contracts, :foreign_key => :created_by, :dependent => :destroy
  has_many :recepients, :class_name => 'Contract', :foreign_key => :recepient_id, :dependent => :destroy
  has_many :timesheets, :foreign_key => :created_by, :dependent => :destroy
  has_many :client_contracts, :class_name => "Contract", :foreign_key => :client_id, :dependent => :destroy

  has_one :contract_default, :dependent => :destroy
  accepts_nested_attributes_for :contract_default, :allow_destroy => true

  has_one :is_primary, :class_name => "Address", :as => :addressable, :dependent => :destroy, :conditions => ["is_primary = 1"]

  has_many :addresses, :class_name => "Address", :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :addresses
  
  has_one :timesheet_default, :as => :timeable, :dependent => :destroy
  accepts_nested_attributes_for :timesheet_default, :allow_destroy => true
  
  has_one :invoice_default, :as => :invoiceable, :dependent => :destroy
  accepts_nested_attributes_for :invoice_default, :allow_destroy => true
  
  has_many :skills, :as => :skillable, :dependent => :destroy
  accepts_nested_attributes_for :skills
  
  has_many :phone_numbers
  accepts_nested_attributes_for :phone_numbers

  has_many :user_access_list
  accepts_nested_attributes_for :user_access_list
  
  has_many  :attachments, :as => :attachable, :dependent => :destroy
  accepts_nested_attributes_for :attachments
  
  has_many :companies
  has_one :search_contract
  has_one :search_contractor

  has_many :company_users
  belongs_to :secret_question
  belongs_to :language
  belongs_to :payment_term

  acts_as_authentic do |c|
    c.login_field = :email
  end

  attr_accessor :agreement

  validates_presence_of :first_name, :last_name, :secret_question, :secret_answer
  validates_length_of   :first_name, :last_name, :maximum => 50, :allow_nil => true, :allow_blank => true
  validates_acceptance_of :agreement

  before_create :set_user_preference
  before_update :save_skill, :save_number, :save_attachment, :save_user_access_list
  
  before_create :create_default_timesheets_invoice

  #starts: named scope
  named_scope :find_all_users, lambda { |company_id, user_id| {
    :joins => "INNER JOIN company_users ON company_users.user_id = users.id INNER JOIN user_preferences ON user_preferences.user_id = users.id",
    :conditions => ["company_users.company_id = ? AND user_preferences.contact_me = true AND users.id != ?", company_id, user_id]
    }}

  named_scope :allow_users, lambda { |user_id| {
    :joins => :user_access_lists,
    :conditions => ["user_access_lists.access_user_id = ? AND status = 'Allow'", user_id]
    }
  }

  named_scope :block_users, lambda { |user_id| {
    :joins => :user_access_lists,
    :conditions => ["user_access_lists.access_user_id = ? AND status = 'Block'", user_id]
    }
  }

  named_scope :find_users_for_timesheet_option, lambda { |contract_id| {
      :include => [:contracts, :contract_default], :conditions => ["contracts.id = ? OR contracts.parent_id = ? AND contract_defaults.allow_timesheet = true", contract_id, contract_id]
    }
  }
  
  #ends: named scope
  def find_time_sheet(timesheet_id)
    return Timesheet.find(:first, :include => :contract, :conditions => ["timesheets.id = ? AND (timesheets.created_by = ? OR contracts.created_by = ?)", timesheet_id, id, id])
  end

  def time_unit
    time_base = self.timesheet_default.time_base.name
    case time_base
    when "Day"
      return TimeUnit.find(:all, :limit => 3, :order => "id ASC")
    when "Week"
      return TimeUnit.find(:all, :limit => 4, :order => "id ASC")
    when "Month"
      return TimeUnit.find(:all, :limit => 5, :order => "id ASC")
    default
      return TimeUnit.all
    end
  end

  # create the field at the time of registration with the default values.
  def create_default_timesheets_invoice
    self.build_timesheet_default
    self.build_invoice_default
    self.build_contract_default
  end

  def to_param
    name = "#{first_name}-#{last_name}"
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  def set_user_preference
    self.build_user_preference
  end

  def active?
    active
  end

  def is_creator?(company)
   if self.companies.include?(company)
     true
   else
     false
   end
  end

  def activate!
    self.active = true
    save
  end

  def name
    "#{first_name} #{last_name}"
  end

  def weekly_recieved
    recieves = ProposeContract.find_all_by_recipient_id(self.id, :conditions => ['created_at >= ?', 7.days.ago])
    contracts = []
    recieves.each  do |c|
      if !c.contract.nil?
        contracts << c.contract unless c.contract.status.eql?("rejected")
      end
    end
    
    contracts
  end

  def weekly_rec_timesheet
    contracts = Contract.find_all_by_status("approved", :conditions => ['created_by = ?', self.id])
    ts = []
    contracts.each do |c|
     ts1 = c.timesheets.find(:all, :conditions => ['status = ? and created_at >= ?', "submitted", 1.month.ago])
      if ts1
        ts1.each do |ts1|
          ts << ts1
        end
      end
    end
    ts
  end

  def monthly_rec_timesheet
    contracts = Contract.find_all_by_status("approved", :conditions => ['created_by = ?', self.id])
    ts = []
    contracts.each do |c|
      ts1 = c.timesheets.find(:all, :conditions => ['status = ? and created_at >= ?', "submitted", 1.month.ago])
      if ts1
        ts1.each do |ts1|
          ts << ts1
        end
      end
      
    end
    ts
  end
  
  def monthly_recieved
    recieves = ProposeContract.find_all_by_recipient_id(self.id, :conditions => ['created_at >= ?', 1.month.ago])
    contracts = []
    recieves.each  do |c|
      if !c.contract.nil?
        contracts << c.contract unless c.contract.status.eql?("rejected")
      end
    end
    contracts
  end


  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def new_phone_number_attributes=(phone_number_attributes)
    phone_number_attributes.each do |pn|
      phone_numbers.build(pn)
    end
  end

   def existing_phone_number_attributes=(phone_number_attributes)
    phone_numbers.reject(&:new_record?).each do |pn|
      attributes = phone_number_attributes[pn.id.to_s]
      if attributes
        pn.attributes = attributes
      else
        phone_numbers.delete(pn)
      end
    end
  end

   def save_number
    phone_numbers.each { |pn| pn.save(false) }
  end

   def new_skill_attributes=(skill_attributes)
     skill_attributes.each do |s|
       skills.build(s)
     end
   end

   def existing_skill_attributes=(skill_attributes)
    skills.reject(&:new_record?).each do |s|
      attributes = skill_attributes[s.id.to_s]
      if attributes
        s.attributes = attributes
      else
        skills.delete(s)
      end
    end
  end

  def save_skill
    skills.each { |s| s.save(false) }
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

   def new_user_access_list_attributes=(user_access_list_attributes)
    user_access_list_attributes.each do |ua|
      user_access_lists.build(ua)
    end
  end

   def existing_user_access_list_attributes=(user_access_list_attributes)
    user_access_lists.reject(&:new_record?).each do |ua|
      attributes = user_access_list_attributes[ua.id.to_s]
      if attributes
        ua.attributes = attributes
      else
        user_access_lists.delete(ua)
      end
    end
  end

   def save_user_access_list
    user_access_lists.each { |ua| ua.save(false) }
  end

  def new_addresses_attributes=(addresses_attributes)
    addresses_attributes.each do |add|
      addresses.build(add)
    end
  end

  def existing_address_attributes=(address_attributes)
    addresses.reject(&:new_record?).each do |add|
      attributes = address_attributes[add.id.to_s]
      if attributes
        add.attributes = attributes
      else
        addresses.delete(pn)
      end
    end
  end

  def save_address
    addresses.each do |add|
        add.save(false)
      end
  end

  
end
