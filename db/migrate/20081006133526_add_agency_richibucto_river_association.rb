class AddAgencyRichibuctoRiverAssociation < ActiveRecord::Migration
  class Agency < ActiveRecord::Base
    set_table_name  'cdAgency'
    set_primary_key 'AgencyCd'
  end
  
  def self.up
    agency = Agency.new
    agency.write_attribute('Agency', 'Richibucto River Watershed')
    agency.write_attribute('AgencyType', 'NGO')
    agency.write_attribute('DataRulesInd', 'N')
    agency.id = 'RICH'
    agency.save!
  end

  def self.down
    Agency.destroy 'RICH'
  end
end
