$:.unshift(File.dirname(__FILE__))
require 'lib/ms_access'

mdb_file = 'C:/Documents and Settings/nbdata/Desktop/data entry/WaterChemTables.mdb'
dynamic_ctl_file = File.dirname(__FILE__) + '/import_from_access_table.ctl'
tables = ["cdAgency", "cdAquaticActivity", "cdAquaticActivityMethod", "cdInstrument",
  "cdMeasureInstrument", "cdMeasureUnit", "cdOandM", "cdOandMValues", "cdUnitofMeasure",
  "tblAquaticActivity", "tblAquaticSite", "tblAquaticSiteAgencyUse", "tblObservations",
  "tblSample", "tblSiteMeasurement", "tblWaterBody", "tblWaterMeasurement"]

#load_mdb_schema(mdb_file, :only => tables)

tables.each do |table| 
    ETL::Engine.process ETL::Control::Control.parse_dynamic(mdb_file, table, dynamic_ctl_file)
end