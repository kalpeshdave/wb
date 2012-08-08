class PaymentTerm < ActiveRecord::Base
  NAMES = find(:all, :order => :name).map do |t|
    [t.name, t.id]
  end
  
  has_many :users
  has_many :invoice_defaults
end
