class ProposeContract < ActiveRecord::Base
  belongs_to :contract

  validates_presence_of :recipient, :description
  validates_uniqueness_of :contract_id, :message => "You have already invited."

  after_create :send_mail
  
  private
  def send_mail
    UserNotifier.deliver_propose_contract(self)
  end
  
end
