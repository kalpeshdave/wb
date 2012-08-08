class Skill < ActiveRecord::Base
  belongs_to :skillable, :polymorphic => true
  validates_uniqueness_of :name, :scope => [:skillable_id, :skillable_type]
end
