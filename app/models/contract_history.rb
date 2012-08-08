class ContractHistory < ActiveRecord::Base
  belongs_to :contract
  belongs_to :user

  include AASM

  aasm_column :action

  aasm_initial_state :entered

  aasm_state :accept
  aasm_state :rejected
  aasm_state :edited
  aasm_state :entered

  aasm_event :enter do
    transitions :to => :incomplete
  end
  
end
