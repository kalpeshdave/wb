class InvoiceDefault < ActiveRecord::Base
  belongs_to :payment_term
  belongs_to :currency
  
  belongs_to :invoiceable, :polymorphic => true
end
