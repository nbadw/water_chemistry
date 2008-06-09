class TblAquaticSite < ActiveRecord::Base
  generator_for :name => 'AquaticSiteName'
  generator_for :description => 'Dummy description...'
end