class GmapLocation < ActiveRecord::Base
  belongs_to :locatable, :polymorphic => true
end
