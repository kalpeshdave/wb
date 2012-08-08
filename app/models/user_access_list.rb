class UserAccessList < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :user_access_list, :class_name => 'User', :foreign_key => :access_user_id

  validates_uniqueness_of :access_user_id, :message => "User has already been taken."

  aasm_column :status

  aasm_initial_state :allow
  
  aasm_state :allow
  aasm_state :block

  aasm_event :allow do
    transitions :to => :allow
  end

  aasm_event :block do
    transitions :to => :block
  end

end
