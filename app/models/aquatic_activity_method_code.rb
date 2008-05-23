class AquaticActivityMethodCode < ActiveRecord::Base
  acts_as_importable 'cdAquaticActivityMethod', :primary_key => 'AquaticMethodCd'
end
