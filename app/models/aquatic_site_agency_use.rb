class AquaticSiteAgencyUse < ActiveRecord::Base
  acts_as_importable 'tblAquaticSiteAgencyUse', :primary_key => 'AquaticSiteUseID', :exclude => ['SSMA_Timestamp']
  import_transformation_for 'EndYear', 'end_year'
end
