class Place < ActiveRecord::Base
  belongs_to :placable, :polymorphic => true
end
