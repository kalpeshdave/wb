class Company < ActiveRecord::Base
  NAMES = find(:all, :order => :name).map do |t|
    [t.name, t.id]
  end
  
  belongs_to :user

  has_many :company_users
  has_many :users, :through => :company_users
  has_many :contracts

  #Establishes polymorphic relationship for model in which it is defined
  has_one :is_primary, :class_name => "Address", :as => :addressable, :dependent => :destroy, :conditions => ["is_primary = 1"]
  
  has_many :addresses, :class_name => "Address", :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :addresses
  
  validates_presence_of :name

  #before_save :save_address
  #before_update :save_address

  # need to update the code...
  # need to find a better sql single line query ... to avoid conditions.
  def find_users(user_id)
    user = User.find_all_users(self.id, user_id)
    allow_user = User.allow_users(user_id)
    block_user = User.block_users(user_id)
    
    if !user.nil? && !allow_user.nil?
      all_user = user + allow_user
      block_user.each { |b| all_user.delete(b) } if block_user
      return all_user
    else
      all_user = user ||= allow_user
      block_user.each { |b| all_user.delete(b) } if block_user
      return all_user
    end
  end
  
  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end

  def use(user)
    company_users = self.company_users.build({ :user_id => user.id })
    company_users.save!
  end

  def current_user_is_owner?(user_id)
    return self.user_id.eql?(user_id) ? true : false
  end
end
