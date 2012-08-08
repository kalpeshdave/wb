class TimesheetOption < ActiveRecord::Base
  belongs_to :user
  belongs_to :contract

  include AASM
  
  aasm_column :visibility
  
  aasm_initial_state :view_only
  
  aasm_state :view_only
  aasm_state :approver


end
