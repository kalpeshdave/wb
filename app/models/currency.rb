class Currency < ActiveRecord::Base
  NAMES = find(:all, :order => :iso_name).map do |t|
    [t.iso_name, t.id]
  end
  has_many :contracts
  has_many :invoice_defaults
end
