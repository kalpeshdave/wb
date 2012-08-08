class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true

  named_scope :order_by_primary, :order => "is_primary DESC"
end
