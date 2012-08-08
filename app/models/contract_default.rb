class ContractDefault < ActiveRecord::Base
  belongs_to :user
  belongs_to :time_unit
  belongs_to :time_base

  validates_length_of :contract_prefix, :maximum => 13, :allow_nil => true, :allow_blank => true
  validates_length_of :last_contract_number, :maximum => 13, :allow_nil => true, :allow_blank => true
  validate :contract_number

  def contract_number
    contract_number = contract_prefix.to_s + last_contract_number.to_s
    errors.add_to_base("Contract Prefix and Last Contract Number can't be more than 15 characters.") if contract_number.length > 15
  end

end

