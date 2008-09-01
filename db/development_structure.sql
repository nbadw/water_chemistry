CREATE TABLE `cdagency` (
  `Agency` varchar(60) default NULL,
  `AgencyCd` varchar(5) NOT NULL default '',
  `AgencyType` varchar(4) default NULL,
  `DataRulesInd` varchar(1) default NULL,
  PRIMARY KEY  (`AgencyCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdaquaticactivity` (
  `AquaticActivityCd` int(11) NOT NULL auto_increment,
  `AquaticActivity` varchar(50) default NULL,
  `AquaticActivityCategory` varchar(30) default NULL,
  `Duration` varchar(20) default NULL,
  PRIMARY KEY  (`AquaticActivityCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdaquaticactivitymethod` (
  `AquaticMethodCd` int(11) NOT NULL auto_increment,
  `AquaticActivityCd` int(11) default '0',
  `AquaticMethod` varchar(30) default NULL,
  PRIMARY KEY  (`AquaticMethodCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdinstrument` (
  `InstrumentCd` int(11) NOT NULL auto_increment,
  `Instrument` varchar(50) default NULL,
  `Instrument_Category` varchar(50) default NULL,
  PRIMARY KEY  (`InstrumentCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdmeasureinstrument` (
  `MeasureInstrumentCd` int(11) NOT NULL auto_increment,
  `InstrumentCd` int(11) default '0',
  `OandMCd` int(11) default '0',
  PRIMARY KEY  (`MeasureInstrumentCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdmeasureunit` (
  `MeasureUnitCd` int(11) NOT NULL auto_increment,
  `OandMCd` int(11) default '0',
  `UnitofMeasureCd` int(11) default '0',
  PRIMARY KEY  (`MeasureUnitCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdoandm` (
  `OandMCd` int(11) NOT NULL auto_increment,
  `BankInd` tinyint(1) default '0',
  `FishPassageInd` tinyint(1) default '0',
  `OandM_Category` varchar(40) default NULL,
  `OandM_DetailsInd` tinyint(1) default '0',
  `OandM_Group` varchar(50) default NULL,
  `OandM_Parameter` varchar(50) default NULL,
  `OandM_ParameterCd` varchar(30) default NULL,
  `OandM_Type` varchar(16) default NULL,
  `OandM_ValuesInd` tinyint(1) default NULL,
  PRIMARY KEY  (`OandMCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdoandmvalues` (
  `OandMValuesCd` int(11) NOT NULL auto_increment,
  `OandMCd` int(11) default '0',
  `Value` varchar(20) default NULL,
  PRIMARY KEY  (`OandMValuesCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdunitofmeasure` (
  `UnitofMeasureCd` int(11) NOT NULL auto_increment,
  `UnitofMeasure` varchar(50) default NULL,
  `UnitofMeasureAbv` varchar(10) default NULL,
  PRIMARY KEY  (`UnitofMeasureCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdwaterchemistryqualifier` (
  `Qualifier` varchar(100) default NULL,
  `QualifierCd` varchar(4) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdwaterparameter` (
  `WaterParameterCd` int(11) NOT NULL auto_increment,
  `WaterParameter` varchar(50) default NULL,
  PRIMARY KEY  (`WaterParameterCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdwatersource` (
  `WaterSource` varchar(20) default NULL,
  `WaterSourceCd` varchar(4) default NULL,
  `WaterSourceType` varchar(20) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` bigint(11) NOT NULL,
  `user_id` bigint(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `rolename` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblaquaticactivity` (
  `AquaticActivityCd` int(11) NOT NULL auto_increment,
  `Agency2Cd` varchar(4) default NULL,
  `Agency2Contact` varchar(50) default NULL,
  `AgencyCd` varchar(4) default NULL,
  `AirTemp_C` float default NULL,
  `AquaticActivityEndDate` varchar(10) default NULL,
  `AquaticActivityEndTime` varchar(6) default NULL,
  `AquaticActivityID` int(11) default NULL,
  `AquaticActivityLeader` varchar(50) default NULL,
  `AquaticActivityStartDate` varchar(10) default NULL,
  `AquaticActivityStartTime` varchar(6) default NULL,
  `AquaticMethodCd` int(11) default NULL,
  `AquaticProgramID` int(11) default NULL,
  `AquaticSiteID` int(11) default NULL,
  `Comments` varchar(250) default NULL,
  `Crew` varchar(50) default NULL,
  `DateEntered` datetime default NULL,
  `DateTransferred` datetime default NULL,
  `IncorporatedInd` tinyint(1) default NULL,
  `oldAquaticSiteID` int(11) default NULL,
  `PermitNo` varchar(20) default NULL,
  `PrimaryActivityInd` tinyint(1) default NULL,
  `Project` varchar(100) default NULL,
  `Siltation` varchar(50) default NULL,
  `TempAquaticActivityID` int(11) default NULL,
  `WaterLevel` varchar(6) default NULL,
  `WaterLevel_AM_cm` varchar(50) default NULL,
  `WaterLevel_cm` varchar(50) default NULL,
  `WaterLevel_PM_cm` varchar(50) default NULL,
  `WaterTemp_C` float default NULL,
  `WeatherConditions` varchar(50) default NULL,
  `Year` varchar(4) default NULL,
  PRIMARY KEY  (`AquaticActivityCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblaquaticsite` (
  `AquaticSiteID` int(11) NOT NULL auto_increment,
  `AquaticSiteDesc` varchar(250) default NULL,
  `AquaticSiteName` varchar(100) default NULL,
  `Comments` varchar(150) default NULL,
  `CoordinateSource` varchar(50) default NULL,
  `CoordinateSystem` varchar(50) default NULL,
  `CoordinateUnits` varchar(50) default NULL,
  `DateEntered` datetime default NULL,
  `EndDesc` varchar(100) default NULL,
  `EndRouteMeas` decimal(10,0) default NULL,
  `GeoReferencedInd` varchar(1) default NULL,
  `HabitatDesc` varchar(50) default NULL,
  `IncorporatedInd` tinyint(1) default NULL,
  `oldAquaticSiteID` int(11) default NULL,
  `ReachNo` int(11) default NULL,
  `RiverSystemID` int(11) default NULL,
  `SiteType` varchar(20) default NULL,
  `SpecificSiteInd` varchar(1) default NULL,
  `StartDesc` varchar(100) default NULL,
  `StartRouteMeas` decimal(10,0) default NULL,
  `WaterBodyID` int(11) default NULL,
  `WaterBodyName` varchar(50) default NULL,
  `XCoordinate` varchar(50) default NULL,
  `YCoordinate` varchar(50) default NULL,
  PRIMARY KEY  (`AquaticSiteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblaquaticsiteagencyuse` (
  `AquaticSiteUseID` int(11) NOT NULL auto_increment,
  `AgencyCd` varchar(4) default NULL,
  `AgencySiteID` varchar(16) default NULL,
  `AquaticActivityCd` int(11) default NULL,
  `AquaticSiteID` int(11) default NULL,
  `AquaticSiteType` varchar(30) default NULL,
  `DateEntered` datetime default NULL,
  `EndYear` varchar(4) default NULL,
  `IncorporatedInd` tinyint(1) default NULL,
  `StartYear` varchar(4) default NULL,
  `YearsActive` varchar(20) default NULL,
  PRIMARY KEY  (`AquaticSiteUseID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tbldrainageunit` (
  `Area_ha` decimal(10,0) default NULL,
  `Area_percent` decimal(10,0) default NULL,
  `BorderInd` varchar(1) default NULL,
  `DrainageCd` varchar(17) NOT NULL default '',
  `Level1Name` varchar(40) default NULL,
  `Level1No` varchar(2) default NULL,
  `Level2Name` varchar(50) default NULL,
  `Level2No` varchar(2) default NULL,
  `Level3Name` varchar(50) default NULL,
  `Level3No` varchar(2) default NULL,
  `Level4Name` varchar(50) default NULL,
  `Level4No` varchar(2) default NULL,
  `Level5Name` varchar(50) default NULL,
  `Level5No` varchar(2) default NULL,
  `Level6Name` varchar(50) default NULL,
  `Level6No` varchar(2) default NULL,
  `StreamOrder` int(11) default NULL,
  `UnitName` varchar(55) default NULL,
  `UnitType` varchar(4) default NULL,
  PRIMARY KEY  (`DrainageCd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblenvironmentalobservations` (
  `EnvObservationID` int(11) NOT NULL auto_increment,
  `AquaticActivityID` int(11) default '0',
  `FishPassageObstructionInd` tinyint(1) default NULL,
  `Observation` varchar(50) default NULL,
  `ObservationGroup` varchar(50) default NULL,
  `ObservationSupp` varchar(50) default NULL,
  `PipeSize_cm` int(11) default '0',
  PRIMARY KEY  (`EnvObservationID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblobservations` (
  `ObservationID` int(11) NOT NULL auto_increment,
  `AquaticActivityID` int(11) default NULL,
  `FishPassageObstructionInd` tinyint(1) default NULL,
  `OandM_Details` varchar(150) default NULL,
  `OandMCd` int(11) default NULL,
  `OandMValuesCd` int(11) default NULL,
  PRIMARY KEY  (`ObservationID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblsitemeasurement` (
  `SiteMeasurementID` int(11) NOT NULL auto_increment,
  `AquaticActivityID` int(11) NOT NULL,
  `Bank` varchar(10) default NULL,
  `InstrumentCd` int(11) default NULL,
  `Measurement` decimal(10,0) default NULL,
  `OandM_Other` varchar(20) default NULL,
  `OandMCd` int(11) default NULL,
  `UnitofMeasureCd` int(11) default NULL,
  PRIMARY KEY  (`SiteMeasurementID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblwaterbody` (
  `WaterBodyID` int(11) NOT NULL auto_increment,
  `DateEntered` datetime default NULL,
  `DateModified` datetime default NULL,
  `DrainageCd` varchar(17) default NULL,
  `FlowIntoDrainageCd` varchar(17) default NULL,
  `FlowsIntoWaterBodyID` decimal(10,0) default NULL,
  `FlowsIntoWaterBodyName` varchar(40) default NULL,
  `Surveyed_Ind` varchar(1) default NULL,
  `WaterBodyComplexID` int(11) default NULL,
  `WaterBodyName` varchar(55) default NULL,
  `WaterBodyName_Abrev` varchar(40) default NULL,
  `WaterBodyName_Alt` varchar(40) default NULL,
  `WaterBodyTypeCd` varchar(4) default NULL,
  PRIMARY KEY  (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblwaterchemistryanalysis` (
  `AL_X` decimal(10,0) default NULL,
  `AL_XGF` decimal(10,0) default NULL,
  `ALK_G` decimal(10,0) default NULL,
  `ALK_P` decimal(10,0) default NULL,
  `ALK_T` decimal(10,0) default NULL,
  `AquaticActivityID` int(11) default '0',
  `AS_XGF` decimal(10,0) default NULL,
  `B_X` decimal(10,0) default NULL,
  `BA_X` decimal(10,0) default NULL,
  `BICARB` decimal(10,0) default '0',
  `BR` decimal(10,0) default NULL,
  `CA_D` decimal(10,0) default NULL,
  `CARB` decimal(10,0) default '0',
  `CD_XGF` decimal(10,0) default NULL,
  `CHL_A` decimal(10,0) default NULL,
  `CL` decimal(10,0) default NULL,
  `CL_IC` decimal(10,0) default NULL,
  `CLRA` decimal(10,0) default NULL,
  `CO_X` decimal(10,0) default NULL,
  `COND` decimal(10,0) default NULL,
  `COND2` decimal(10,0) default '0',
  `CR_X` decimal(10,0) default NULL,
  `CR_XGF` decimal(10,0) default NULL,
  `CU_X` decimal(10,0) default NULL,
  `CU_XGF` decimal(10,0) default NULL,
  `DO` decimal(10,0) default NULL,
  `DOC` decimal(10,0) default NULL,
  `DOE_FieldNo` varchar(11) default NULL,
  `DOE_LabNo` varchar(8) default NULL,
  `DOE_Program` varchar(14) default NULL,
  `DOE_ProjectNo` varchar(10) default NULL,
  `DOE_StationNo` varchar(15) default NULL,
  `F` decimal(10,0) default NULL,
  `FE_X` decimal(10,0) default NULL,
  `HARD` decimal(10,0) default NULL,
  `HG_T` decimal(10,0) default NULL,
  `K` decimal(10,0) default NULL,
  `L_AL_X` varchar(1) default NULL,
  `L_AL_XGF` varchar(1) default NULL,
  `L_ALK_G` varchar(1) default NULL,
  `L_ALK_P` varchar(1) default NULL,
  `L_ALK_T` varchar(1) default NULL,
  `L_AS_XGF` varchar(1) default NULL,
  `L_B_X` varchar(1) default NULL,
  `L_BA_X` varchar(1) default NULL,
  `L_BR` varchar(1) default NULL,
  `L_CA_D` varchar(1) default NULL,
  `L_CD_XGF` varchar(1) default NULL,
  `L_CHL_A` varchar(1) default NULL,
  `L_CL` varchar(1) default NULL,
  `L_CL_IC` varchar(1) default NULL,
  `L_CLRA` varchar(1) default NULL,
  `L_CO_X` varchar(1) default NULL,
  `L_COND` varchar(1) default NULL,
  `L_CR_X` varchar(1) default NULL,
  `L_CR_XGF` varchar(1) default NULL,
  `L_CU_X` varchar(1) default NULL,
  `L_CU_XGF` varchar(1) default NULL,
  `L_DOC` varchar(1) default NULL,
  `L_F` varchar(1) default NULL,
  `L_FE_X` varchar(1) default NULL,
  `L_HARD` varchar(1) default NULL,
  `L_HG_T` varchar(1) default NULL,
  `L_K` varchar(1) default NULL,
  `L_MG_D` varchar(1) default NULL,
  `L_MN_X` varchar(1) default NULL,
  `L_NA` varchar(1) default NULL,
  `L_NH3T` varchar(1) default NULL,
  `L_NI_X` varchar(1) default NULL,
  `L_NO2D` varchar(1) default NULL,
  `L_NOX` varchar(1) default NULL,
  `L_O_PHOS` varchar(1) default NULL,
  `L_PB_XGF` varchar(1) default NULL,
  `L_PH` varchar(1) default NULL,
  `L_PH_GAL` varchar(1) default NULL,
  `L_SB_XGF` varchar(1) default NULL,
  `L_SE_XGF` varchar(1) default NULL,
  `L_SO4` varchar(1) default NULL,
  `L_SO4_IC` varchar(1) default NULL,
  `L_SS` varchar(1) default NULL,
  `L_TDS` varchar(1) default NULL,
  `L_TKN` varchar(1) default NULL,
  `L_TL_XGF` varchar(1) default NULL,
  `L_TOC` varchar(1) default NULL,
  `L_TP_L` varchar(1) default NULL,
  `L_TURB` varchar(1) default NULL,
  `L_ZN_X` varchar(1) default NULL,
  `L_ZN_XGF` varchar(1) default NULL,
  `MG_D` decimal(10,0) default NULL,
  `MN_X` decimal(10,0) default NULL,
  `NA` decimal(10,0) default NULL,
  `NH3T` decimal(10,0) default NULL,
  `NI_X` decimal(10,0) default NULL,
  `NO2D` decimal(10,0) default NULL,
  `NO3` decimal(10,0) default NULL,
  `NOX` decimal(10,0) default NULL,
  `O_PHOS` decimal(10,0) default '0',
  `PB_XGF` decimal(10,0) default NULL,
  `PH` decimal(10,0) default NULL,
  `PH_GAL` decimal(10,0) default NULL,
  `SampleDepth_m` decimal(10,0) default NULL,
  `SAT_NDX` decimal(10,0) default '0',
  `SAT_PH` decimal(10,0) default '0',
  `SB_XGF` decimal(10,0) default NULL,
  `SE_XGF` decimal(10,0) default NULL,
  `SecchiDepth_m` decimal(10,0) default NULL,
  `SILICA` decimal(10,0) default '0',
  `SO4` decimal(10,0) default NULL,
  `SO4_IC` decimal(10,0) default NULL,
  `SS` decimal(10,0) default NULL,
  `TDS` decimal(10,0) default NULL,
  `TempAquaticActivityID` int(11) default '0',
  `TKN` decimal(10,0) default NULL,
  `TL_XGF` decimal(10,0) default NULL,
  `TOC` decimal(10,0) default NULL,
  `TOXIC_UNIT` decimal(10,0) default NULL,
  `TP_L` decimal(10,0) default NULL,
  `TURB` decimal(10,0) default NULL,
  `WaterTemp_C` decimal(10,0) default NULL,
  `ZN_X` decimal(10,0) default NULL,
  `ZN_XGF` decimal(10,0) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblwatermeasurement` (
  `WaterMeasurementID` int(11) NOT NULL auto_increment,
  `AquaticActivityID` int(11) default NULL,
  `Comment` varchar(255) default NULL,
  `HabitatUnitID` int(11) default NULL,
  `InstrumentCd` int(11) default NULL,
  `Measurement` float default NULL,
  `OandMCd` int(11) default NULL,
  `QualifierCd` varchar(20) default NULL,
  `SampleID` int(11) default NULL,
  `TempAquaticActivityID` int(11) default NULL,
  `TempDataID` int(11) default '0',
  `TemperatureLoggerID` int(11) default '0',
  `TimeofDay` varchar(5) default NULL,
  `UnitofMeasureCd` int(11) default NULL,
  `WaterDepth_m` float default NULL,
  `WaterSourceCd` varchar(50) default NULL,
  PRIMARY KEY  (`WaterMeasurementID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `activation_code` varchar(40) default NULL,
  `activated_at` datetime default NULL,
  `password_reset_code` varchar(40) default NULL,
  `enabled` tinyint(1) default '1',
  `agency_id` varchar(5) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `last_login` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `water_chemistry_parameters` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `code` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `imported_at` datetime default NULL,
  `exported_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `water_chemistry_sample_results` (
  `id` int(11) NOT NULL auto_increment,
  `water_chemistry_sample_id` bigint(11) default NULL,
  `water_chemistry_parameter_id` bigint(11) default NULL,
  `instrument_id` bigint(11) default NULL,
  `unit_of_measure_id` bigint(11) default NULL,
  `value` float default NULL,
  `qualifier` varchar(255) default NULL,
  `comment` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `water_chemistry_samples` (
  `id` int(11) NOT NULL auto_increment,
  `aquatic_activity_event_id` bigint(11) default NULL,
  `agency_sample_no` varchar(10) default NULL,
  `sample_depth_in_m` float default NULL,
  `water_source_type` varchar(20) default NULL,
  `sample_collection_method` varchar(255) default NULL,
  `analyzed_by` varchar(255) default NULL,
  `imported_at` datetime default NULL,
  `exported_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');