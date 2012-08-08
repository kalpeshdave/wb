class Position < ActiveRecord::Base
  belongs_to :positionable, :polymorphic => true
end
