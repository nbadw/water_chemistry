CREATE TABLE `auxlakeswithdepths` (
  `WaterBodyID` double(15,5) default NULL,
  `WaterBodyName` varchar(40) default NULL,
  `DrainageCd` varchar(17) default NULL,
  `WaterBodyTypeCd` varchar(4) default NULL,
  `StartRouteMeas` double(15,5) default NULL,
  `EndRouteMeas` double(15,5) default NULL,
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `auxlakeswithsurveys` (
  `WaterBodyID` double(15,5) default NULL,
  `WaterBodyName` varchar(40) default NULL,
  `DrainageCd` varchar(17) default NULL,
  `WaterBodyTypeCd` varchar(4) default NULL,
  `StartRouteMeas` double(15,5) default NULL,
  `EndRouteMeas` double(15,5) default NULL,
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `auxstockedwaters` (
  `WaterBodyID` double(15,5) default NULL,
  `WaterBodyName` varchar(50) default NULL,
  `DrainageCd` varchar(17) default NULL,
  `WaterBodyTypeCd` varchar(4) default NULL,
  `StartRouteMeas` double(15,5) default NULL,
  `EndRouteMeas` double(15,5) default NULL,
  KEY `WATERID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `auxstreamswithsurveys` (
  `RIVER_SYS` smallint(5) default NULL,
  `WaterBodyID` double(15,5) default NULL,
  `WaterBodyName` varchar(40) default NULL,
  `DrainageCd` varchar(17) default NULL,
  `STARTPOINT` varchar(50) default NULL,
  `ENDPOINT` varchar(50) default NULL,
  `StreamLength_km` double(15,5) default NULL,
  `StartRouteMeas` double(15,5) default NULL,
  `EndRouteMeas` double(15,5) default NULL,
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `auxuserdbelectrofishingfopestimate` (
  `EFPopulationEstimateID` int(10) NOT NULL auto_increment,
  `oldEFPopulationEstimateID` int(10) default NULL,
  `EFDataID` int(10) default NULL,
  `TempDataID` int(10) default NULL,
  `oldEFDataID` double(15,5) default NULL,
  `EFMRDataID` int(10) default NULL,
  `EFDataInd` tinyint(1) NOT NULL,
  `AquaticActivityID` int(10) default NULL,
  `OLDAquaticActivityID` double(15,5) default NULL,
  `Formula` varchar(26) default NULL,
  `FishSpeciesCd` varchar(2) default NULL,
  `FishAgeClass` varchar(10) default NULL,
  `RelativeSizeClass` varchar(10) default NULL,
  `AveForkLength_cm` double(15,5) default NULL,
  `AveWeight_gm` double(15,5) default NULL,
  `PopulationParameter` varchar(20) default NULL,
  `PopulationEstimate` double(15,5) default NULL,
  `AutoCalculatedInd` tinyint(1) NOT NULL,
  `Comments` varchar(100) default NULL,
  PRIMARY KEY  (`EFPopulationEstimateID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `EFASSMT_ID` (`OLDAquaticActivityID`),
  KEY `EFDATA_ID` (`oldEFDataID`),
  KEY `EFDataID` (`EFDataID`),
  KEY `EFPopulationEstimateID` (`oldEFPopulationEstimateID`),
  KEY `EFPopulationEstimateID1` (`EFPopulationEstimateID`),
  KEY `TempEFDataID` (`TempDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `auxuserdbnonrestrictedactivityids` (
  `AgencyCd` varchar(4) default NULL,
  `AquaticActivityID` int(10) default NULL,
  `AquaticActivityCd` smallint(5) default NULL,
  `AquaticActivity` varchar(50) default NULL,
  `AquaticActivityStartDate` varchar(10) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `auxuserdbselectedactivities` (
  `AquaticActivityID` int(10) default NULL,
  `DrainageCd` varchar(17) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `auxuserdbselectedsites` (
  `AquaticSiteUseID` int(10) NOT NULL auto_increment,
  `AquaticSiteID` int(10) default NULL,
  `AquaticActivityCd` smallint(5) default NULL,
  `AgencyCd` varchar(4) default NULL,
  `DrainageCd` varchar(17) default NULL,
  PRIMARY KEY  (`AquaticSiteUseID`)
) ENGINE=InnoDB AUTO_INCREMENT=6171 DEFAULT CHARSET=utf8;

CREATE TABLE `auxuserdbselectedsiteuse` (
  `AquaticSiteUseID` int(10) NOT NULL auto_increment,
  `AquaticSiteID` int(10) default NULL,
  `AquaticActivityCd` smallint(5) default NULL,
  `AgencyCd` varchar(4) default NULL,
  `DrainageCd` varchar(17) default NULL,
  PRIMARY KEY  (`AquaticSiteUseID`)
) ENGINE=InnoDB AUTO_INCREMENT=6782 DEFAULT CHARSET=utf8;

CREATE TABLE `cdagency` (
  `AgencyCd` varchar(5) NOT NULL,
  `Agency` varchar(60) default NULL,
  `AgencyType` varchar(4) default NULL,
  `DataRulesInd` varchar(1) default NULL,
  PRIMARY KEY  (`AgencyCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdaquaticactivity` (
  `AquaticActivityCd` smallint(5) NOT NULL,
  `AquaticActivity` varchar(50) default NULL,
  `AquaticActivityCategory` varchar(30) default NULL,
  `Duration` varchar(20) default NULL,
  PRIMARY KEY  (`AquaticActivityCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdaquaticactivitymethod` (
  `AquaticMethodCd` smallint(5) NOT NULL,
  `AquaticActivityCd` smallint(5) default NULL,
  `AquaticMethod` varchar(30) default NULL,
  PRIMARY KEY  (`AquaticMethodCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdcountyparish` (
  `CountyParishID` int(10) NOT NULL auto_increment,
  `OldCountyCd` varchar(10) default NULL,
  `NewCountyCd` varchar(11) default NULL,
  `County` varchar(17) default NULL,
  `OldParishCd` varchar(10) default NULL,
  `NewParishCd` varchar(12) default NULL,
  `Parish` varchar(22) default NULL,
  `OldCountyParishCd` varchar(6) default NULL,
  `NewCountyParishCd` varchar(7) default NULL,
  PRIMARY KEY  (`CountyParishID`),
  KEY `CountyParishID` (`CountyParishID`),
  KEY `NewCountyCd` (`NewCountyCd`),
  KEY `NewParishCd` (`NewParishCd`)
) ENGINE=InnoDB AUTO_INCREMENT=154 DEFAULT CHARSET=utf8;

CREATE TABLE `cdenvironmentalobservations` (
  `ObservationID` int(10) NOT NULL auto_increment,
  `ObservationCategory` varchar(40) default NULL,
  `ObservationGroup` varchar(50) default NULL,
  `Observation` varchar(50) default NULL,
  PRIMARY KEY  (`ObservationID`),
  KEY `ObservationID` (`ObservationID`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishageclass` (
  `FishAgeClass` varchar(25) NOT NULL,
  `FishAgeClassCategory` varchar(20) default NULL,
  `StockingInd` tinyint(1) NOT NULL,
  `ElectrofishInd` tinyint(1) NOT NULL,
  `FishCountInd` tinyint(1) NOT NULL,
  PRIMARY KEY  (`FishAgeClass`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishmark` (
  `FishMarkCd` int(10) NOT NULL,
  `FishMark` varchar(50) default NULL,
  PRIMARY KEY  (`FishMarkCd`),
  KEY `Fin Status Code` (`FishMarkCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishmortalitycause` (
  `MortalityCauseCd` int(10) NOT NULL,
  `CauseOfMortality` varchar(50) default NULL,
  PRIMARY KEY  (`MortalityCauseCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishparasiteclass` (
  `ParasiteClassCd` varchar(4) NOT NULL,
  `ParasiteClass` varchar(20) default NULL,
  `Location` varchar(24) default NULL,
  PRIMARY KEY  (`ParasiteClassCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishpopulationformula` (
  `FormulaCd` int(10) NOT NULL auto_increment,
  `Formula` varchar(20) default NULL,
  PRIMARY KEY  (`FormulaCd`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishpopulationparameter` (
  `PopulationParameter` varchar(20) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishspecies` (
  `FishSpeciesCd` varchar(2) NOT NULL,
  `FishSpecies` varchar(30) default NULL,
  `StockedInd` tinyint(1) NOT NULL,
  `ElectrofishInd` tinyint(1) NOT NULL,
  PRIMARY KEY  (`FishSpeciesCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishstatus` (
  `FishStatusCd` varchar(10) NOT NULL,
  `FishStatus` varchar(50) default NULL,
  `FishStatusType` varchar(20) default NULL,
  PRIMARY KEY  (`FishStatusCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdfishstomachcontent` (
  `StomachContentCd` int(10) NOT NULL auto_increment,
  `StomachContent` varchar(20) default NULL,
  PRIMARY KEY  (`StomachContentCd`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `cdhabitatunitcomment` (
  `CommentCd` varchar(2) NOT NULL,
  `Comment` varchar(30) default NULL,
  PRIMARY KEY  (`CommentCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdinstrument` (
  `InstrumentCd` int(10) NOT NULL auto_increment,
  `Instrument` varchar(50) default NULL,
  `Instrument_Category` varchar(50) default NULL,
  PRIMARY KEY  (`InstrumentCd`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE `cdmeasureinstrument` (
  `MeasureInstrumentCd` int(10) NOT NULL auto_increment,
  `OandMCd` int(10) default NULL,
  `InstrumentCd` int(10) default NULL,
  PRIMARY KEY  (`MeasureInstrumentCd`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8;

CREATE TABLE `cdmeasureunit` (
  `MeasureUnitCd` int(10) NOT NULL auto_increment,
  `OandMCd` int(10) default NULL,
  `UnitofMeasureCd` int(10) default NULL,
  PRIMARY KEY  (`MeasureUnitCd`),
  KEY `cdMeasureUnitOandMCd` (`OandMCd`),
  KEY `cdMeasureUnitUnitofMeasureCd` (`UnitofMeasureCd`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;

CREATE TABLE `cdoandm` (
  `OandMCd` int(10) NOT NULL auto_increment,
  `OandM_Type` varchar(16) default NULL,
  `OandM_Category` varchar(40) default NULL,
  `OandM_Group` varchar(50) default NULL,
  `OandM_Parameter` varchar(50) default NULL,
  `OandM_ParameterCd` varchar(30) default NULL,
  `OandM_ValuesInd` tinyint(1) NOT NULL,
  `OandM_DetailsInd` tinyint(1) NOT NULL,
  `FishPassageInd` tinyint(1) NOT NULL,
  `BankInd` tinyint(1) NOT NULL,
  PRIMARY KEY  (`OandMCd`),
  KEY `ObservationID` (`OandMCd`)
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8;

CREATE TABLE `cdoandmvalues` (
  `OandMValuesCd` int(10) NOT NULL auto_increment,
  `OandMCd` int(10) default NULL,
  `Value` varchar(20) default NULL,
  PRIMARY KEY  (`OandMValuesCd`),
  KEY `O&M_ID` (`OandMCd`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

CREATE TABLE `cdsamplecollectionmethod` (
  `SampleMethodCd` int(10) NOT NULL auto_increment,
  `SampleMethod` varchar(30) default NULL,
  `Description` varchar(255) default NULL,
  PRIMARY KEY  (`SampleMethodCd`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `cdsamplegear` (
  `SampleGearCd` int(10) NOT NULL auto_increment,
  `SampleGear` varchar(20) default NULL,
  PRIMARY KEY  (`SampleGearCd`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE `cdsex` (
  `SexCd` varchar(1) NOT NULL,
  `Sex` varchar(10) default NULL,
  PRIMARY KEY  (`SexCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdstreamchanneltype` (
  `ChannelCd` varchar(1) NOT NULL,
  `ChannelType` varchar(6) default NULL,
  PRIMARY KEY  (`ChannelCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdstreamembeddedness` (
  `EmbeddedCd` varchar(1) NOT NULL,
  `Embeddedness` varchar(10) default NULL,
  PRIMARY KEY  (`EmbeddedCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdstreamtype` (
  `StreamTypeCd` varchar(2) NOT NULL,
  `StreamType` varchar(24) default NULL,
  `StreamTypeGroup` varchar(6) default NULL,
  PRIMARY KEY  (`StreamTypeCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdunitofmeasure` (
  `UnitofMeasureCd` int(10) NOT NULL,
  `UnitofMeasure` varchar(50) default NULL,
  `UnitofMeasureAbv` varchar(10) default NULL,
  PRIMARY KEY  (`UnitofMeasureCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdwaterchemistryqualifier` (
  `QualifierCd` varchar(4) NOT NULL,
  `Qualifier` varchar(100) default NULL,
  PRIMARY KEY  (`QualifierCd`),
  KEY `cdWaterChemistryQualifierQualif` (`QualifierCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdwaterparameter` (
  `WaterParameterCd` int(10) NOT NULL,
  `WaterParameter` varchar(50) default NULL,
  PRIMARY KEY  (`WaterParameterCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdwatersource` (
  `WaterSourceCd` varchar(4) NOT NULL,
  `WaterSource` varchar(20) default NULL,
  `WaterSourceType` varchar(20) default NULL,
  PRIMARY KEY  (`WaterSourceCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `cdwatersourcetype` (
  `WaterSourceType` varchar(30) NOT NULL,
  PRIMARY KEY  (`WaterSourceType`),
  KEY `cdWaterSourceTypeWaterSourceType` (`WaterSourceType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` bigint(11) NOT NULL,
  `user_id` bigint(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `rolename` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `rpttblbasinorderingscheme` (
  `Level1No` varchar(2) NOT NULL,
  `Level1Name` varchar(40) default NULL,
  `OceanName` varchar(20) default NULL,
  `Level1Area_km2` double(15,5) default NULL,
  `Level1Area_Percent` double(15,5) default NULL,
  `Order` int(10) default NULL,
  PRIMARY KEY  (`Level1No`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblanglinglease` (
  `RegulatedWaterID` int(10) NOT NULL,
  `LeaseNo` smallint(5) default NULL,
  `LeaseDesc` varchar(254) default NULL,
  `StreamLength_km` double(15,5) default NULL,
  `NoRodsPerDay` smallint(5) default NULL,
  `NoRodsPerYear` varchar(24) default NULL,
  `ExpiryYear` varchar(4) default NULL,
  `LodgeName` varchar(20) default NULL,
  `Lessee` varchar(45) default NULL,
  `LesseeAddress1` varchar(30) default NULL,
  `LesseeAddress2` varchar(20) default NULL,
  `LesseeCity` varchar(20) default NULL,
  `LesseProv` varchar(2) default NULL,
  `LesseePostalCd` varchar(7) default NULL,
  `Contact1` varchar(20) default NULL,
  `Contact1Title` varchar(20) default NULL,
  `Contact1Dept` varchar(25) default NULL,
  `Contact1Phone` varchar(14) default NULL,
  `Contact1Fax` varchar(14) default NULL,
  `Contact2` varchar(24) default NULL,
  `Contact2Title` varchar(20) default NULL,
  `Contact2Dept` varchar(20) default NULL,
  `Contact2Phone` varchar(14) default NULL,
  `Contact2Fax` varchar(14) default NULL,
  `Manager` varchar(21) default NULL,
  `ManagerPhone` varchar(14) default NULL,
  PRIMARY KEY  (`RegulatedWaterID`),
  KEY `{D3655704-EBA1-41D7-8CCB-412119` (`RegulatedWaterID`),
  KEY `LEASE_ID` (`LeaseNo`),
  KEY `RegulatedWatersID` (`RegulatedWaterID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblanglinglicensesales` (
  `LicenseSalesID` int(10) NOT NULL auto_increment,
  `LicenseCd` int(10) default NULL,
  `Residence` varchar(255) default NULL,
  `LicenseType` varchar(255) default NULL,
  `LicenseClass` varchar(255) default NULL,
  `LicenseDesc` varchar(255) default NULL,
  `Year` int(10) default NULL,
  `NoSold` int(10) default NULL,
  PRIMARY KEY  (`LicenseSalesID`)
) ENGINE=InnoDB AUTO_INCREMENT=1401 DEFAULT CHARSET=utf8;

CREATE TABLE `tblaquaticactivity` (
  `AquaticActivityID` int(10) NOT NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `Project` varchar(100) default NULL,
  `PermitNo` varchar(20) default NULL,
  `AquaticProgramID` int(10) default NULL,
  `AquaticActivityCd` smallint(5) default NULL,
  `AquaticMethodCd` smallint(5) default NULL,
  `oldAquaticSiteID` int(10) default NULL,
  `AquaticSiteID` int(10) default NULL,
  `AquaticActivityStartDate` varchar(10) default NULL,
  `AquaticActivityEndDate` varchar(10) default NULL,
  `AquaticActivityStartTime` varchar(6) default NULL,
  `AquaticActivityEndTime` varchar(6) default NULL,
  `Year` varchar(4) default NULL,
  `AgencyCd` varchar(4) default NULL,
  `Agency2Cd` varchar(4) default NULL,
  `Agency2Contact` varchar(50) default NULL,
  `AquaticActivityLeader` varchar(50) default NULL,
  `Crew` varchar(50) default NULL,
  `WeatherConditions` varchar(50) default NULL,
  `WaterTemp_C` double(7,2) default NULL,
  `AirTemp_C` double(7,2) default NULL,
  `WaterLevel` varchar(6) default NULL,
  `WaterLevel_cm` varchar(50) default NULL,
  `WaterLevel_AM_cm` varchar(50) default NULL,
  `WaterLevel_PM_cm` varchar(50) default NULL,
  `Siltation` varchar(50) default NULL,
  `PrimaryActivityInd` tinyint(1) NOT NULL,
  `Comments` varchar(250) default NULL,
  `DateEntered` datetime default NULL,
  `IncorporatedInd` tinyint(1) NOT NULL,
  `DateTransferred` datetime default NULL,
  PRIMARY KEY  (`AquaticActivityID`),
  KEY `{33D6B2E4-F11A-47D1-BFE4-EE52E8` (`AquaticSiteID`),
  KEY `{66945D2F-F4E9-46B3-B601-8B4AC0` (`AquaticActivityCd`),
  KEY `{86A93E88-27E1-4293-8F8F-51509C` (`AquaticProgramID`),
  KEY `{D79D562C-FC0D-4C7B-AF79-95EFDA` (`Agency2Cd`),
  KEY `{DBF31B0D-A36E-42EC-A246-E33178` (`AgencyCd`),
  KEY `{FFCC8125-2385-49D8-9E05-364C40` (`Agency2Cd`),
  KEY `AquaticActivityID1` (`AquaticActivityID`),
  KEY `AquaticProgramID` (`AquaticProgramID`),
  KEY `FisheriesSiteID` (`AquaticSiteID`),
  KEY `OldAquaticActivityID` (`TempAquaticActivityID`),
  KEY `oldAquaticSiteID` (`oldAquaticSiteID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblaquaticprogram` (
  `AquaticProgramID` int(10) NOT NULL,
  `AquaticProgramName` varchar(30) default NULL,
  `AquaticProgramPurpose` varchar(150) default NULL,
  `AquaticProgramStartDate` datetime default NULL,
  `AquaticProgramEndDate` datetime default NULL,
  `AgencyCd` varchar(4) default NULL,
  `AquaticProgramLeader` varchar(50) default NULL,
  PRIMARY KEY  (`AquaticProgramID`),
  KEY `{D2FEB2BB-F414-4F7D-8613-ACB906` (`AgencyCd`),
  KEY `AquaticProgramID` (`AquaticProgramID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblaquaticsite` (
  `AquaticSiteID` int(10) NOT NULL,
  `oldAquaticSiteID` int(10) default NULL,
  `RiverSystemID` smallint(5) default NULL,
  `WaterBodyID` int(10) default NULL,
  `WaterBodyName` varchar(50) default NULL,
  `AquaticSiteName` varchar(100) default NULL,
  `AquaticSiteDesc` varchar(250) default NULL,
  `HabitatDesc` varchar(50) default NULL,
  `ReachNo` int(10) default NULL,
  `StartDesc` varchar(100) default NULL,
  `EndDesc` varchar(100) default NULL,
  `StartRouteMeas` double(15,5) default NULL,
  `EndRouteMeas` double(15,5) default NULL,
  `SiteType` varchar(20) default NULL,
  `SpecificSiteInd` varchar(1) default NULL,
  `GeoReferencedInd` varchar(1) default NULL,
  `DateEntered` datetime default NULL,
  `IncorporatedInd` tinyint(1) NOT NULL,
  `CoordinateSource` varchar(50) default NULL,
  `CoordinateSystem` varchar(50) default NULL,
  `XCoordinate` varchar(50) default NULL,
  `YCoordinate` varchar(50) default NULL,
  `CoordinateUnits` varchar(50) default NULL,
  `Comments` varchar(150) default NULL,
  PRIMARY KEY  (`AquaticSiteID`),
  KEY `{047A49A9-3B29-47B9-B429-4EBFC4` (`WaterBodyID`),
  KEY `{A85D1309-1E35-4A86-8D76-67637B` (`RiverSystemID`),
  KEY `AssmtSiteID` (`AquaticSiteID`),
  KEY `oldAquaticSiteID` (`oldAquaticSiteID`),
  KEY `RiverSystemID` (`RiverSystemID`),
  KEY `WaterBodyID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblaquaticsiteagencyuse` (
  `AquaticSiteUseID` int(10) NOT NULL auto_increment,
  `AquaticSiteID` int(10) default NULL,
  `AquaticActivityCd` smallint(5) default NULL,
  `AquaticSiteType` varchar(30) default NULL,
  `AgencyCd` varchar(4) default NULL,
  `AgencySiteID` varchar(16) default NULL,
  `StartYear` varchar(4) default NULL,
  `EndYear` varchar(4) default NULL,
  `YearsActive` varchar(20) default NULL,
  `DateEntered` datetime default NULL,
  `IncorporatedInd` tinyint(1) NOT NULL,
  PRIMARY KEY  (`AquaticSiteUseID`),
  KEY `{AE11D8D8-9E33-4740-BC97-E80094` (`AquaticSiteID`),
  KEY `AgencySiteID` (`AgencySiteID`),
  KEY `AssmtSiteID` (`AquaticSiteUseID`),
  KEY `WaterBodyID` (`AquaticSiteID`)
) ENGINE=InnoDB AUTO_INCREMENT=7003 DEFAULT CHARSET=utf8;

CREATE TABLE `tblbacterialanalysis` (
  `BacterialAnalysisID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `DOE_LabNo` varchar(8) default NULL,
  `DOE_FieldNo` varchar(10) default NULL,
  `SampleDepth_m` double(15,5) default NULL,
  `WaterTemp_C` double(15,5) default NULL,
  `QualifierA` varchar(2) default NULL,
  `FaecalColiformCount_A` double(15,5) default NULL,
  `QualifierB` varchar(2) default NULL,
  `FaecalColiformCount_B` double(15,5) default NULL,
  `L_TotalColiforms` varchar(1) default NULL,
  `TotalColiforms` int(10) default NULL,
  `Ecoli` double(15,5) default NULL,
  PRIMARY KEY  (`BacterialAnalysisID`),
  KEY `{B0CA8FCD-3C0D-4472-B2A9-904822` (`AquaticActivityID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `BacterialAnalysisID` (`BacterialAnalysisID`),
  KEY `OldAquaticActivityID` (`TempAquaticActivityID`)
) ENGINE=InnoDB AUTO_INCREMENT=602 DEFAULT CHARSET=utf8;

CREATE TABLE `tblbroodstockcollection` (
  `AquaticActivityID` int(10) NOT NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `Wild_M_MSW` double(15,5) default NULL,
  `Wild_F_MSW` double(15,5) default NULL,
  `Clipped_M_MSW` double(15,5) default NULL,
  `Clipped_F_MSW` double(15,5) default NULL,
  `Total_M_MSW` double(15,5) default NULL,
  `Total_F_MSW` double(15,5) default NULL,
  `Total_MSW` double(15,5) default NULL,
  `Wild_M_Grilse` double(15,5) default NULL,
  `Wild_F_Grilse` double(15,5) default NULL,
  `Clipped_M_Grilse` double(15,5) default NULL,
  `Clipped_F_Grilse` double(15,5) default NULL,
  `Total_M_Grilse` double(15,5) default NULL,
  `Total_F_Grilse` double(15,5) default NULL,
  `Total_Grilse` double(15,5) default NULL,
  `Total_F_ASalmon` double(15,5) default NULL,
  `Total_M_ASalmon` double(15,5) default NULL,
  `Total_ASalmon` double(15,5) default NULL,
  `Comments` varchar(250) default NULL,
  PRIMARY KEY  (`AquaticActivityID`),
  KEY `{980D252C-07FE-480B-9235-EA23BD` (`AquaticActivityID`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblcrownreserve` (
  `RegulatedWaterID` int(10) NOT NULL,
  `AnglingFishSpecies` varchar(20) default NULL,
  `StreamLength_km` double(15,5) default NULL,
  `NoPools` smallint(5) default NULL,
  `NoDays` smallint(5) default NULL,
  `MaxRodPerDay` smallint(5) default NULL,
  `AccommodationsInd` varchar(1) default NULL,
  `StartYear` varchar(10) default NULL,
  `EndYear` varchar(10) default NULL,
  `ActiveInd` varchar(1) default NULL,
  PRIMARY KEY  (`RegulatedWaterID`),
  KEY `{2F73944A-EE45-4C58-B41D-F6542A` (`RegulatedWaterID`),
  KEY `RegulatedWatersID` (`RegulatedWaterID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tbldraingeunit` (
  `DrainageCd` varchar(17) NOT NULL,
  `Level1No` varchar(2) default NULL,
  `Level1Name` varchar(40) default NULL,
  `Level2No` varchar(2) default NULL,
  `Level2Name` varchar(50) default NULL,
  `Level3No` varchar(2) default NULL,
  `Level3Name` varchar(50) default NULL,
  `Level4No` varchar(2) default NULL,
  `Level4Name` varchar(50) default NULL,
  `Level5No` varchar(2) default NULL,
  `Level5Name` varchar(50) default NULL,
  `Level6No` varchar(2) default NULL,
  `Level6Name` varchar(50) default NULL,
  `UnitName` varchar(55) default NULL,
  `UnitType` varchar(4) default NULL,
  `BorderInd` varchar(1) default NULL,
  `StreamOrder` smallint(5) default NULL,
  `Area_ha` double(15,5) default NULL,
  `Area_percent` double(15,5) default NULL,
  PRIMARY KEY  (`DrainageCd`),
  KEY `{C26A40DF-1604-4BE7-BDBD-F8BC6C` (`Level1No`),
  KEY `tblDraingeUnitsDrainageCd` (`DrainageCd`),
  KEY `tblDraingeUnitsLevel1No` (`Level1No`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblelectrofishingdata` (
  `EFDataID` int(10) NOT NULL auto_increment,
  `oldEFDataID` double(15,5) default NULL,
  `TempDataID` int(10) default NULL,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` double(15,5) default NULL,
  `FishSpeciesCd` varchar(2) default NULL,
  `FishAgeClass` varchar(10) default NULL,
  `RelativeSizeClass` varchar(10) default NULL,
  `AveWeight_gm` double(15,5) default NULL,
  `AveForkLength_cm` double(15,5) default NULL,
  `AveTotalLength_cm` double(15,5) default NULL,
  `Sweep1NoFish` double(15,5) default NULL,
  `Sweep1Time_s` double(15,5) default NULL,
  `Sweep2NoFish` double(15,5) default NULL,
  `Sweep2Time_s` double(15,5) default NULL,
  `Sweep3NoFish` double(15,5) default NULL,
  `Sweep3Time_s` double(15,5) default NULL,
  `Sweep4NoFish` double(15,5) default NULL,
  `Sweep4Time_s` double(15,5) default NULL,
  `Sweep5NoFish` double(15,5) default NULL,
  `Sweep5Time_s` double(15,5) default NULL,
  `Sweep6NoFish` double(15,5) default NULL,
  `Sweep6Time_s` double(15,5) default NULL,
  `TotalNoSweeps` int(10) default NULL,
  `TotalNoFish` double(15,5) default NULL,
  `PercentClipped` double(15,5) default NULL,
  `Comments` varchar(100) default NULL,
  `DW_Comments` varchar(100) default NULL,
  PRIMARY KEY  (`EFDataID`),
  KEY `{196E57D0-3F38-43B2-B4E7-3A9546` (`AquaticActivityID`),
  KEY `{3307D7AA-47A2-4D30-B30E-4596D1` (`FishSpeciesCd`),
  KEY `{D2C885E2-CCEF-47E5-AF27-170490` (`FishAgeClass`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `EFASSMT_ID` (`TempAquaticActivityID`),
  KEY `EFDATA_ID` (`oldEFDataID`),
  KEY `EFDataID` (`EFDataID`),
  KEY `TempEFDataID` (`TempDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=39414 DEFAULT CHARSET=utf8;

CREATE TABLE `tblelectrofishingmarkrecapturedata` (
  `EFMRDataID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` double(15,5) default NULL,
  `TempDataID` int(10) default NULL,
  `RecaptureTime` smallint(5) default NULL,
  `FishSpeciesCd` varchar(2) default NULL,
  `FishAgeClass` varchar(10) default NULL,
  `AveWeight_gm` double(15,5) default NULL,
  `AveForkLength_cm` double(15,5) default NULL,
  `AveTotalLength_cm` double(15,5) default NULL,
  `MarkCount` double(15,5) default NULL,
  `MarkMarked` double(15,5) default NULL,
  `MarkMorts` double(15,5) default NULL,
  `RecaptureCount` double(15,5) default NULL,
  `RecaptureUnmarked` double(15,5) default NULL,
  `RecaptureMarked` double(15,5) default NULL,
  `RecaptureMorts` double(15,5) default NULL,
  `MarkEfficiency` double(15,5) default NULL,
  `Comments` varchar(100) default NULL,
  `DW_Comments` varchar(100) default NULL,
  PRIMARY KEY  (`EFMRDataID`),
  KEY `{22F2CEBB-F47B-4837-8840-C009FB` (`FishAgeClass`),
  KEY `{B2C296E5-A98F-454E-A7A0-2A3DFE` (`AquaticActivityID`),
  KEY `{E1056899-F963-4116-855D-6F47EE` (`FishSpeciesCd`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `EFASSMT_ID` (`TempAquaticActivityID`),
  KEY `EFDATA_ID` (`EFMRDataID`),
  KEY `TempDataID` (`TempDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=961 DEFAULT CHARSET=utf8;

CREATE TABLE `tblelectrofishingmethoddetail` (
  `AquaticActivityDetailID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `Device` varchar(20) default NULL,
  `SiteSetup` varchar(6) default NULL,
  `NoSweeps` smallint(5) default NULL,
  `StreamLength_m` double(7,2) default NULL,
  `Area_m2` double(7,2) default NULL,
  `Voltage` double(15,5) default NULL,
  `Frequency_Hz` double(15,5) default NULL,
  `DutyCycle` double(15,5) default NULL,
  `POWSetting` double(15,5) default NULL,
  PRIMARY KEY  (`AquaticActivityDetailID`),
  KEY `{974003F4-D516-4FAA-9C71-2FC24E` (`AquaticActivityID`),
  KEY `AquaticActivityDetailsID` (`AquaticActivityDetailID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `AssmtPrgrmID` (`TempAquaticActivityID`)
) ENGINE=InnoDB AUTO_INCREMENT=4126 DEFAULT CHARSET=utf8;

CREATE TABLE `tblelectrofishingpopulationestimate` (
  `EFPopulationEstimateID` int(10) NOT NULL auto_increment,
  `oldEFPopulationEstimateID` int(10) default NULL,
  `EFDataID` int(10) default NULL,
  `TempDataID` int(10) default NULL,
  `oldEFDataID` double(15,5) default NULL,
  `EFMRDataID` int(10) default NULL,
  `EFDataInd` tinyint(1) NOT NULL,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` double(15,5) default NULL,
  `Formula` varchar(26) default NULL,
  `FishSpeciesCd` varchar(2) default NULL,
  `FishAgeClass` varchar(10) default NULL,
  `RelativeSizeClass` varchar(10) default NULL,
  `AveForkLength_cm` double(15,5) default NULL,
  `AveWeight_gm` double(15,5) default NULL,
  `PopulationParameter` varchar(20) default NULL,
  `PopulationEstimate` double(15,5) default NULL,
  `AutoCalculatedInd` tinyint(1) NOT NULL,
  `Comments` varchar(100) default NULL,
  PRIMARY KEY  (`EFPopulationEstimateID`),
  KEY `{3054E6F5-67BE-4433-BA0D-203C0F` (`FishAgeClass`),
  KEY `{619029C0-02D2-4149-BE10-808545` (`AquaticActivityID`),
  KEY `{D6A691C5-AB3C-4A65-9711-F88235` (`FishSpeciesCd`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `EFASSMT_ID` (`TempAquaticActivityID`),
  KEY `EFDATA_ID` (`oldEFDataID`),
  KEY `EFDataID` (`EFDataID`),
  KEY `EFPopulationEstimateID` (`oldEFPopulationEstimateID`),
  KEY `EFPopulationEstimateID1` (`EFPopulationEstimateID`),
  KEY `TempEFDataID` (`TempDataID`)
) ENGINE=InnoDB AUTO_INCREMENT=67665 DEFAULT CHARSET=utf8;

CREATE TABLE `tblenvironmentalobservations` (
  `EnvObservationID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `ObservationGroup` varchar(50) default NULL,
  `Observation` varchar(50) default NULL,
  `ObservationSupp` varchar(50) default NULL,
  `PipeSize_cm` int(10) default NULL,
  `FishPassageObstructionInd` tinyint(1) NOT NULL,
  PRIMARY KEY  (`EnvObservationID`),
  UNIQUE KEY `EnvObservationID` (`EnvObservationID`),
  KEY `AquaticActivityID` (`AquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblenvironmentalplanning` (
  `EnvPlanningID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `IssueCategory` varchar(50) default NULL,
  `Issue` varchar(250) default NULL,
  `ActionRequired` varchar(250) default NULL,
  `ActionTargetDate` datetime default NULL,
  `ActionPriority` smallint(5) default NULL,
  `ActionCompletionDate` datetime default NULL,
  `FollowUpRequired` tinyint(1) NOT NULL,
  `FollowUpTargetDate` datetime default NULL,
  `FollowUpCompletionDate` datetime default NULL,
  PRIMARY KEY  (`EnvPlanningID`),
  UNIQUE KEY `EnvPlanningID` (`EnvPlanningID`),
  KEY `AquaticActivityID` (`AquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblenvironmentalsurveyfieldmeasures` (
  `FieldMeasureID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `StreamCover` varchar(10) default NULL,
  `BankStability` varchar(20) default NULL,
  `BankSlope_Rt` smallint(5) default NULL,
  `BankSlope_Lt` smallint(5) default NULL,
  `StreamType` varchar(10) default NULL,
  `StreamTypeSupp` varchar(30) default NULL,
  `SuspendedSilt` tinyint(1) NOT NULL,
  `EmbeddedSub` tinyint(1) NOT NULL,
  `AquaticPlants` tinyint(1) NOT NULL,
  `Algae` tinyint(1) NOT NULL,
  `Petroleum` tinyint(1) NOT NULL,
  `Odor` tinyint(1) NOT NULL,
  `Foam` tinyint(1) NOT NULL,
  `DeadFish` tinyint(1) NOT NULL,
  `Other` tinyint(1) NOT NULL,
  `OtherSupp` varchar(50) default NULL,
  `Length_m` double(7,2) default NULL,
  `AveWidth_m` double(7,2) default NULL,
  `AveDepth_m` double(7,2) default NULL,
  `Velocity_mpers` double(7,2) default NULL,
  `WaterClarity` varchar(16) default NULL,
  `WaterColor` varchar(10) default NULL,
  `Weather_Past` varchar(20) default NULL,
  `Weather_Current` varchar(20) default NULL,
  `RZ_Lawn_Lt` smallint(5) default NULL,
  `RZ_Lawn_Rt` double(7,2) default NULL,
  `RZ_RowCrop_Lt` smallint(5) default NULL,
  `RZ_RowCrop_Rt` smallint(5) default NULL,
  `RZ_ForageCrop_Lt` smallint(5) default NULL,
  `RZ_ForageCrop_Rt` smallint(5) default NULL,
  `RZ_Shrubs_Lt` smallint(5) default NULL,
  `RZ_Shrubs_Rt` smallint(5) default NULL,
  `RZ_Hardwood_Lt` smallint(5) default NULL,
  `RZ_Hardwood_Rt` smallint(5) default NULL,
  `RZ_Softwood_Lt` smallint(5) default NULL,
  `RZ_Softwood_Rt` smallint(5) default NULL,
  `RZ_Mixed_Lt` smallint(5) default NULL,
  `RZ_Mixed_Rt` smallint(5) default NULL,
  `RZ_Meadow_Lt` smallint(5) default NULL,
  `RZ_Meadow_Rt` smallint(5) default NULL,
  `RZ_Wetland_Lt` smallint(5) default NULL,
  `RZ_Wetland_Rt` smallint(5) default NULL,
  `RZ_Altered_Lt` smallint(5) default NULL,
  `RZ_Altered_Rt` smallint(5) default NULL,
  `ST_TimeofDay` varchar(5) default NULL,
  `ST_DissOxygen` double(7,2) default NULL,
  `ST_AirTemp_C` double(7,2) default NULL,
  `ST_WaterTemp_C` double(7,2) default NULL,
  `ST_pH` double(7,2) default NULL,
  `ST_Conductivity` double(7,2) default NULL,
  `ST_Flow_cms` double(7,2) default NULL,
  `ST_DELGFieldNo` varchar(50) default NULL,
  `GW1_TimeofDay` varchar(5) default NULL,
  `GW1_DissOxygen` double(7,2) default NULL,
  `GW1_AirTemp_C` double(7,2) default NULL,
  `GW1_WaterTemp_C` double(7,2) default NULL,
  `GW1_pH` double(7,2) default NULL,
  `GW1_Conductivity` double(7,2) default NULL,
  `GW1_Flow_cms` double(7,2) default NULL,
  `GW1_DELGFieldNo` varchar(50) default NULL,
  `GW2_TimeofDay` varchar(5) default NULL,
  `GW2_DissOxygen` double(7,2) default NULL,
  `GW2_AirTemp_C` double(7,2) default NULL,
  `GW2_WaterTemp_C` double(7,2) default NULL,
  `GW2_pH` double(7,2) default NULL,
  `GW2_Conductivity` double(7,2) default NULL,
  `GW2_Flow_cms` double(7,2) default NULL,
  `GW2_DELGFieldNo` varchar(50) default NULL,
  PRIMARY KEY  (`FieldMeasureID`),
  UNIQUE KEY `FieldMeasureID` (`FieldMeasureID`),
  KEY `AquaticActivityID` (`AquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblfishcount` (
  `FishCountID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `MovementDirection` varchar(4) default NULL,
  `MovementTime` varchar(10) default NULL,
  `FishSpeciesCd` varchar(3) default NULL,
  `FishOrigin` varchar(10) default NULL,
  `FishAgeClass` varchar(12) default NULL,
  `RelativeSizeClass` varchar(10) default NULL,
  `FishAge` varchar(5) default NULL,
  `SexCd` varchar(1) default NULL,
  `NoFish` int(10) default NULL,
  `FishStatusCd` varchar(4) default NULL,
  `RPM` double(15,5) default NULL,
  `RPM Left_Right` varchar(16) default NULL,
  PRIMARY KEY  (`FishCountID`),
  KEY `{06EA6C0C-673D-49A5-80FF-3F8553` (`FishSpeciesCd`),
  KEY `{5D7B660D-0861-4E5F-A43C-FEA1F6` (`SexCd`),
  KEY `{66BB9C3A-7285-4FDB-B4BC-DBCB50` (`AquaticActivityID`),
  KEY `{CAEC13B9-5CC5-4B2A-A167-36394C` (`FishStatusCd`),
  KEY `{E12AAD0E-8C73-403B-9564-76C09F` (`FishAgeClass`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`),
  KEY `FishCountID` (`FishCountID`)
) ENGINE=InnoDB AUTO_INCREMENT=46064 DEFAULT CHARSET=utf8;

CREATE TABLE `tblfishfacility` (
  `FishFacilityID` int(10) NOT NULL,
  `AquaticSiteID` int(10) default NULL,
  `FishFacilityType` varchar(20) default NULL,
  `FishFacilityCategory` varchar(20) default NULL,
  `WaterBodyID` int(10) default NULL,
  `FishFacilityName` varchar(50) default NULL,
  `AgencyCd` varchar(4) default NULL,
  `YearsActive` varchar(20) default NULL,
  `ActiveInd` varchar(15) default NULL,
  PRIMARY KEY  (`FishFacilityID`),
  KEY `{62AE88DB-B6DA-461A-8EFD-79994C` (`AgencyCd`),
  KEY `AquaticSiteID` (`AquaticSiteID`),
  KEY `FishFacilityID` (`FishFacilityID`),
  KEY `WaterBodyID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblfishmating` (
  `FishMatingID` int(10) NOT NULL auto_increment,
  `FishMating` varchar(150) default NULL,
  PRIMARY KEY  (`FishMatingID`),
  KEY `Mating Code` (`FishMatingID`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;

CREATE TABLE `tblfishmeasurement` (
  `FishSampleID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `SweepNo` int(10) default NULL,
  `FishSpeciesCd` varchar(2) default NULL,
  `FishOrigin` varchar(1) default NULL,
  `FishAge` varchar(255) default NULL,
  `FishAgeClass` varchar(20) default NULL,
  `RelativeSizeClass` varchar(6) default NULL,
  `SexCd` varchar(4) default NULL,
  `Maturity` varchar(50) default NULL,
  `FishStatusCd` varchar(25) default NULL,
  `FishMortalityCauseCd` int(10) default NULL,
  `ForkLength_mm` double(15,5) default NULL,
  `TotalLength_mm` double(15,5) default NULL,
  `Weight_gm` double(15,5) default NULL,
  `ObservedMarkCd` int(10) default NULL,
  `ObservedTagTypeCd` varchar(255) default NULL,
  `ObservedTagNo` varchar(255) default NULL,
  `AppliedMarkCd` int(10) default NULL,
  `AppliedTagTypeCd` varchar(255) default NULL,
  `AppliedTagDetails` varchar(50) default NULL,
  `AppliedTagNo` varchar(255) default NULL,
  `ScaleSampleInd` varchar(1) default NULL,
  `KFactor` varchar(255) default NULL,
  `Comments` varchar(255) default NULL,
  PRIMARY KEY  (`FishSampleID`),
  KEY `{3A73ACBD-5E01-4161-A005-936056` (`FishAgeClass`),
  KEY `{5789DFE0-E15C-4411-B206-AB85F6` (`ObservedMarkCd`),
  KEY `{78BF6931-900B-4BA0-9668-0F6ADF` (`FishStatusCd`),
  KEY `{B3899285-6946-4B56-8F15-8CC930` (`FishMortalityCauseCd`),
  KEY `{BAEC7ACC-1DA9-47D4-A524-136D1F` (`AppliedMarkCd`),
  KEY `{C8F34BD0-92BF-465C-9970-616E6A` (`FishSpeciesCd`),
  KEY `{F065211C-F778-44FD-9014-6CD26F` (`SexCd`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`)
) ENGINE=InnoDB AUTO_INCREMENT=285877 DEFAULT CHARSET=utf8;

CREATE TABLE `tblfishstock` (
  `FishStockID` int(10) NOT NULL,
  `FishSpeciesCd` varchar(2) default NULL,
  `WaterBodyID` int(10) default NULL,
  `FishStockName` varchar(150) default NULL,
  `WildStatus` varchar(30) default NULL,
  `RunSeason` varchar(10) default NULL,
  `TriploidInd` tinyint(1) NOT NULL,
  `LandlockedInd` tinyint(1) NOT NULL,
  `FishFacilityID` int(10) default NULL,
  PRIMARY KEY  (`FishStockID`),
  KEY `{9CC37BEE-D922-4454-8E9C-90F6EB` (`FishSpeciesCd`),
  KEY `FishFacilityID` (`FishFacilityID`),
  KEY `FishStockID` (`FishStockID`),
  KEY `WaterBodyID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblfishtranslocation` (
  `FishTranslocationID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `FishStockID` int(10) default NULL,
  `FishAgeClass` varchar(6) default NULL,
  `NoFish` double(15,5) default NULL,
  `ForkLength_cm` double(15,5) default NULL,
  `Weight_gm` double(15,5) default NULL,
  `AppliedMarkCd` int(10) default NULL,
  `AppliedTagNo` varchar(50) default NULL,
  `Source` varchar(50) default NULL,
  PRIMARY KEY  (`FishTranslocationID`),
  KEY `{197AEA6C-6EDA-4CDD-928E-AC3D74` (`FishAgeClass`),
  KEY `{3F66498F-954D-4260-B4DB-340DA6` (`FishStockID`),
  KEY `{C1A7EB34-A8A5-481B-A17D-074E4F` (`AppliedMarkCd`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `FishStockID` (`FishStockID`),
  KEY `FishTranslocationID` (`FishTranslocationID`),
  KEY `OldAquaticActivityID` (`TempAquaticActivityID`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

CREATE TABLE `tblhabitatrestoration` (
  `AquaticActivityID` int(10) NOT NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `RestorationDesc` varchar(150) default NULL,
  PRIMARY KEY  (`AquaticActivityID`),
  KEY `{A405B266-7050-4183-B60D-3AFE5A` (`AquaticActivityID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `OldAquaticActivityID` (`TempAquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblhabitatunit` (
  `HabitatUnitID` double(15,5) NOT NULL,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `RiverSystemID` smallint(5) default NULL,
  `WaterBodyID` double(15,5) default NULL,
  `WaterBodyName` varchar(40) default NULL,
  `StartRouteMeas` double(15,5) default NULL,
  `EndRouteMeas` double(15,5) default NULL,
  `CalibratedLength_m` double(15,5) default NULL,
  `StreamOrder` smallint(5) default NULL,
  `ReachNo` smallint(5) default NULL,
  `HabitatUnitNo` varchar(3) default NULL,
  `StreamTypeCd` varchar(2) default NULL,
  `ChannelCd` varchar(1) default NULL,
  `ChannelPosition` varchar(1) default NULL,
  `StreamLength_m` double(15,5) default NULL,
  `WetWidth_m` double(15,5) default NULL,
  `BankFullWidth_m` double(15,5) default NULL,
  `Area_m2` double(15,5) default NULL,
  `Bedrock` smallint(5) default NULL,
  `Boulder` smallint(5) default NULL,
  `Rock` smallint(5) default NULL,
  `Rubble` smallint(5) default NULL,
  `Gravel` smallint(5) default NULL,
  `Sand` smallint(5) default NULL,
  `Fines` smallint(5) default NULL,
  `TotalLgSubstrate` smallint(5) default NULL,
  `AveDepth_cm` smallint(5) default NULL,
  `UndercutBank_L` smallint(5) default NULL,
  `UndercutBank_R` smallint(5) default NULL,
  `OverhangingVeg_L` smallint(5) default NULL,
  `OverhangingVeg_R` smallint(5) default NULL,
  `WoodyDebrisLength_m` double(15,5) default NULL,
  `WoodyDebrisLengthPer100m2` double(15,5) default NULL,
  `WaterSourceCd` varchar(1) default NULL,
  `WaterFlow_cms` double(15,5) default NULL,
  `AssmtTime` varchar(5) default NULL,
  `WaterTemp_C` double(15,5) default NULL,
  `AirTemp_C` double(15,5) default NULL,
  `EmbeddedCd` varchar(1) default NULL,
  `CommentCds` varchar(150) default NULL,
  `Shade` smallint(5) default NULL,
  `Bank_Bare` smallint(5) default NULL,
  `Bank_Grass` smallint(5) default NULL,
  `Bank_Shrubs` smallint(5) default NULL,
  `Bank_Trees` smallint(5) default NULL,
  `Bank_L_Stable` smallint(5) default NULL,
  `Bank_L_BarelyStable` smallint(5) default NULL,
  `Bank_L_Eroding` smallint(5) default NULL,
  `Bank_R_Stable` smallint(5) default NULL,
  `Bank_R_BarelyStable` smallint(5) default NULL,
  `Bank_R_Eroding` smallint(5) default NULL,
  `FieldNotes` varchar(250) default NULL,
  PRIMARY KEY  (`HabitatUnitID`),
  KEY `{2C20CD7A-D76A-4B79-9722-A2169A` (`ChannelCd`),
  KEY `{4E89055D-2136-4D66-B94B-190547` (`EmbeddedCd`),
  KEY `{77627C39-5B81-431D-8AFC-2A560E` (`StreamTypeCd`),
  KEY `{AFB36345-F8C9-44B0-87E6-4C519B` (`AquaticActivityID`),
  KEY `{B40FC300-BC5B-4B37-B35E-421B87` (`WaterSourceCd`),
  KEY `{F8305F71-FA7B-4614-BD08-B115EB` (`RiverSystemID`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`),
  KEY `HABUNIT_ID` (`HabitatUnitID`),
  KEY `RiverSystemID` (`RiverSystemID`),
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblhabitatunitcomment` (
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `HabitatUnitID` double(15,5) default NULL,
  `CommentCd` varchar(3) default NULL,
  `Comment` varchar(30) default NULL,
  KEY `{1D8D4C80-ED60-4F4D-AD66-AEFD1A` (`HabitatUnitID`),
  KEY `{CE25D1D9-753C-4839-A68F-C3A029` (`CommentCd`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`),
  KEY `HABUNIT_ID` (`HabitatUnitID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblhabitatunitwatermeasurement` (
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `HabitatUnitID` double(15,5) default NULL,
  `WaterSourceCd` varchar(1) default NULL,
  `AssmtTime` varchar(5) default NULL,
  `WaterTemp_C` double(15,5) default NULL,
  `AirTemp_C` double(15,5) default NULL,
  `WaterFlow_cms` double(15,5) default NULL,
  `WaterFlow_gpm` double(15,5) default NULL,
  `WaterFlow_lpm` double(15,5) default NULL,
  KEY `{597706DE-D7FA-4CD5-A07A-B86693` (`HabitatUnitID`),
  KEY `{930FC3B8-C2A8-4C09-B400-AED987` (`WaterSourceCd`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`),
  KEY `HABUNIT_ID` (`HabitatUnitID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tbllakeattribute` (
  `WaterBodyID` int(10) NOT NULL,
  `County` varchar(20) default NULL,
  `Parish` varchar(30) default NULL,
  `LakeClass` varchar(15) default NULL,
  `Area_m2` double(15,5) default NULL,
  `Perimeter_m` double(15,5) default NULL,
  `ShorelineCrown_Percent` int(10) default NULL,
  `ShorelinePrivate_Percent` int(10) default NULL,
  `Depth_Max` double(15,5) default NULL,
  `Depth_Mean` double(15,5) default NULL,
  `Depth_Percent_LT6m` smallint(5) default NULL,
  `Depth_Percent_LT3m` smallint(5) default NULL,
  `StratifiedInd` varchar(2) default NULL,
  `Volume_m3` double(15,5) default NULL,
  `AcreFeet` double(15,5) default NULL,
  `MEI` double(15,5) default NULL,
  `PotentialProductivity` double(15,5) default NULL,
  `WCHIndex` double(15,5) default NULL,
  `SalmonIndex` double(15,5) default NULL,
  `TogueIndex` double(15,5) default NULL,
  `TotalProductivity` double(15,5) default NULL,
  `ShorelineDev` double(15,5) default NULL,
  PRIMARY KEY  (`WaterBodyID`),
  UNIQUE KEY `{4E408586-E3BB-430C-BCE6-FAB4A7` (`WaterBodyID`),
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tbllakesurveydetail` (
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `DNRRegion` varchar(1) default NULL,
  `CountyCd` varchar(2) default NULL,
  `County` varchar(20) default NULL,
  `ParishCd` varchar(3) default NULL,
  `PARISH` varchar(30) default NULL,
  `AirTemp_F` smallint(5) default NULL,
  `Terrain_Flat` smallint(5) default NULL,
  `Terrain_Rolling` smallint(5) default NULL,
  `Terrain_Hilly` smallint(5) default NULL,
  `Terrain_Mountains` smallint(5) default NULL,
  `Forest_Softwood` smallint(5) default NULL,
  `Forest_Hardwood` smallint(5) default NULL,
  `Forest_Soft_Hard` smallint(5) default NULL,
  `Forest_Hard_Soft` smallint(5) default NULL,
  `ShoreUse_Cutover` smallint(5) default NULL,
  `ShoreUse_MatureTimber` smallint(5) default NULL,
  `ShoreUse_ImmatureTimber` smallint(5) default NULL,
  `ShoreUse_Residences` smallint(5) default NULL,
  `ShoreUse_Cottages` smallint(5) default NULL,
  `ShoreUse_Farms` smallint(5) default NULL,
  `ShoreUse_Wetlands` smallint(5) default NULL,
  `AquaticVeg_Submerged` smallint(5) default NULL,
  `AquaticVeg_Emergent` smallint(5) default NULL,
  `ShoreVeg_Sedge` smallint(5) default NULL,
  `ShoreVeg_Heath` smallint(5) default NULL,
  `ShoreVeg_Cedar` smallint(5) default NULL,
  `ShoreVeg_Alder` smallint(5) default NULL,
  `Substrate_Mud` smallint(5) default NULL,
  `Substrate_Sand` smallint(5) default NULL,
  `Substrate_Rubble` smallint(5) default NULL,
  `Substrate_Gravel` smallint(5) default NULL,
  `Substrate_Rock` smallint(5) default NULL,
  `Substrate_Boulders` smallint(5) default NULL,
  `Substrate_Bedrock` smallint(5) default NULL,
  `PublicAccess_Trail` smallint(5) default NULL,
  `PublicAccess_Car` smallint(5) default NULL,
  `PublicAccess_Jeep` smallint(5) default NULL,
  `PublicAccess_Boat` smallint(5) default NULL,
  `PrivateAccess_Trail` smallint(5) default NULL,
  `PrivateAccess_Car` smallint(5) default NULL,
  `PrivateAccess_Jeep` smallint(5) default NULL,
  `PrivateAccess_Boat` smallint(5) default NULL,
  `NoBoatLandings` smallint(5) default NULL,
  `ShoreOwnership_Crown` smallint(5) default NULL,
  `ShoreOwnership_Private` smallint(5) default NULL,
  `NoCamps` smallint(5) default NULL,
  `NoBeaches` smallint(5) default NULL,
  `WoodyDebris` varchar(14) default NULL,
  `ShorelineShape` varchar(16) default NULL,
  `SpawningPotential` varchar(4) default NULL,
  `SecchiDepth_ft` smallint(5) default NULL,
  `WaterColor` varchar(14) default NULL,
  `WaterChemInd` varchar(1) default NULL,
  `AnglingInfoInd` varchar(1) default NULL,
  KEY `{5316EF9C-8A04-4E5D-9CB5-393792` (`AquaticActivityID`),
  KEY `ActivityID` (`AquaticActivityID`),
  KEY `oldAquaticActivityID` (`TempAquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tbllakesurveyfishspecies` (
  `LakeSurveyFishID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `OldAssmtID` smallint(5) default NULL,
  `HoursFished` smallint(5) default NULL,
  `GearType` varchar(20) default NULL,
  `FishSpeciesCd` varchar(2) default NULL,
  `NoFish` smallint(5) default NULL,
  `Length_Min` double(15,5) default NULL,
  `Length_Max` double(15,5) default NULL,
  `PopulationStatus` varchar(8) default NULL,
  PRIMARY KEY  (`LakeSurveyFishID`),
  KEY `{83C4C015-3FED-4A6C-A4CA-11E735` (`AquaticActivityID`),
  KEY `{AC5B557E-7BBC-48AF-A07C-926CB9` (`FishSpeciesCd`),
  KEY `activityid` (`AquaticActivityID`),
  KEY `ASSMT_ID` (`OldAssmtID`),
  KEY `LakeSurveyFishID` (`LakeSurveyFishID`)
) ENGINE=InnoDB AUTO_INCREMENT=1442 DEFAULT CHARSET=utf8;

CREATE TABLE `tbllakesurveytribassessment` (
  `LakeSurveyTribID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `OldAssmtID` smallint(5) default NULL,
  `TributaryName` varchar(20) default NULL,
  `SurveyLength_mi` double(15,5) default NULL,
  `AveWidth_ft` smallint(5) default NULL,
  `WaterLevel` varchar(8) default NULL,
  `Silt` smallint(5) default NULL,
  `Sand` smallint(5) default NULL,
  `Gravel` smallint(5) default NULL,
  `Rubble` smallint(5) default NULL,
  `Rock` smallint(5) default NULL,
  `Boulder` smallint(5) default NULL,
  `Bedrock` smallint(5) default NULL,
  `NurseryLength_ft` smallint(5) default NULL,
  `NurseryWidth_ft` smallint(5) default NULL,
  `NurseryQuality` smallint(5) default NULL,
  `SpawningLength_ft` smallint(5) default NULL,
  `SpawningWidth_ft` smallint(5) default NULL,
  `SpawningQuality` smallint(5) default NULL,
  `NoPools_LT3ftDeep` smallint(5) default NULL,
  `NoPools_3to6ftDeep` smallint(5) default NULL,
  `NoPools_GT6ftDeep` smallint(5) default NULL,
  `ObstructionInd` varchar(1) default NULL,
  `ObstructionType` varchar(10) default NULL,
  `FishwayInd` varchar(1) default NULL,
  `VerticalJump` smallint(5) default NULL,
  `HorizontalJump` smallint(5) default NULL,
  PRIMARY KEY  (`LakeSurveyTribID`),
  KEY `{815C93E0-C509-47BE-939F-B306D3` (`AquaticActivityID`),
  KEY `activityID` (`AquaticActivityID`),
  KEY `ASSMT_ID` (`OldAssmtID`),
  KEY `LakeSurveyTribID` (`LakeSurveyTribID`)
) ENGINE=InnoDB AUTO_INCREMENT=640 DEFAULT CHARSET=utf8;

CREATE TABLE `tbllakesurveywatermeasurement` (
  `LakeSurveyWaterMeasID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `OldAssmtID` smallint(5) default NULL,
  `AirTemp` smallint(5) default NULL,
  `SampleDepth` double(15,5) default NULL,
  `WaterTemp_F` smallint(5) default NULL,
  `DissolvedO2` double(15,5) default NULL,
  `O2Saturation` double(15,5) default NULL,
  `pH` double(15,5) default NULL,
  `PhenoAlkalinity` double(15,5) default NULL,
  `MethylOrangeAlkalinity` double(15,5) default NULL,
  `TotalHardness` double(15,5) default NULL,
  `CO2` double(15,5) default NULL,
  `FreeAcid` double(15,5) default NULL,
  PRIMARY KEY  (`LakeSurveyWaterMeasID`),
  KEY `{FCA583A3-894E-448B-8E19-1E2110` (`AquaticActivityID`),
  KEY `ACTIVITYID` (`AquaticActivityID`),
  KEY `ASSMT_ID` (`OldAssmtID`),
  KEY `FREE_ACID` (`FreeAcid`),
  KEY `LakeSurveyWaterMeasID` (`LakeSurveyWaterMeasID`)
) ENGINE=InnoDB AUTO_INCREMENT=1217 DEFAULT CHARSET=utf8;

CREATE TABLE `tbllevel1basin` (
  `Level1No` varchar(2) NOT NULL,
  `Level1Name` varchar(40) default NULL,
  `OceanName` varchar(20) default NULL,
  `Area_km2` double(15,5) default NULL,
  `Area_Percent` double(15,5) default NULL,
  PRIMARY KEY  (`Level1No`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblobservations` (
  `ObservationID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `OandMCd` int(10) default NULL,
  `OandM_Details` varchar(150) default NULL,
  `OandMValuesCd` int(10) default NULL,
  `FishPassageObstructionInd` tinyint(1) NOT NULL,
  PRIMARY KEY  (`ObservationID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `EnvSurveyID` (`ObservationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tbloldhabitatsurvey` (
  `HabitatSurveyID` int(10) NOT NULL auto_increment,
  `WaterBodyID` double(15,5) default NULL,
  `AgencyCd` varchar(4) default NULL,
  `SectionNo` smallint(5) default NULL,
  `SectionDesc` varchar(50) default NULL,
  `StreamLength_m` double(15,5) default NULL,
  `AveWidth_m` double(15,5) default NULL,
  `Area_m2` double(15,5) default NULL,
  `ProductiveArea` double(15,5) default NULL,
  `NonProductiveArea_m2` double(15,5) default NULL,
  `GoodArea_m2` double(15,5) default NULL,
  `FairArea_m2` double(15,5) default NULL,
  `PoorArea_m2` double(15,5) default NULL,
  `FieldNotes` varchar(150) default NULL,
  PRIMARY KEY  (`HabitatSurveyID`),
  KEY `HabitatSurveyID` (`HabitatSurveyID`),
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB AUTO_INCREMENT=268 DEFAULT CHARSET=utf8;

CREATE TABLE `tblphotos` (
  `PhotoID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `Path` varchar(50) default NULL,
  `FileName` varchar(50) default NULL,
  PRIMARY KEY  (`PhotoID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `PhotoID` (`PhotoID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblreconnaissanceresult` (
  `AquaticActivityID` int(10) NOT NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `StreamTypeCd` varchar(2) default NULL,
  `WetWidth_m` double(15,5) default NULL,
  `BankFullWidth_m` double(15,5) default NULL,
  `Bedrock` smallint(5) default NULL,
  `Boulder` smallint(5) default NULL,
  `Rock` smallint(5) default NULL,
  `Rubble` smallint(5) default NULL,
  `Gravel` smallint(5) default NULL,
  `Sand` smallint(5) default NULL,
  `Fines` smallint(5) default NULL,
  `EmbeddedCd` varchar(1) default NULL,
  `AssmtTime` varchar(4) default NULL,
  `AirTemp_C` double(15,5) default NULL,
  `WaterTemp_C` double(15,5) default NULL,
  `WaterFlow_cms` double(15,5) default NULL,
  PRIMARY KEY  (`AquaticActivityID`),
  KEY `{A1DC03BD-AD41-48A5-BE14-D25FF1` (`StreamTypeCd`),
  KEY `{D8682845-4751-4B5D-BC5F-C5F964` (`EmbeddedCd`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `oldAquaticActivityID` (`TempAquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblreddcount` (
  `AquaticActivityID` int(10) NOT NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `NoSmallRedds` double(15,5) default NULL,
  `NoLargeRedds` double(15,5) default NULL,
  `TotalRedds` double(15,5) default NULL,
  `NoGrilse` double(15,5) default NULL,
  `NoMSW` double(15,5) default NULL,
  `TotalASalmon` double(15,5) default NULL,
  `Comments` varchar(150) default NULL,
  PRIMARY KEY  (`AquaticActivityID`),
  KEY `{222C0077-C2AF-4260-A81C-E9A777` (`AquaticActivityID`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblregulatedwater` (
  `RegulatedWaterID` int(10) NOT NULL auto_increment,
  `WaterBodyID` int(10) default NULL,
  `WaterBodyName` varchar(50) default NULL,
  `RegulatedWaterName` varchar(50) default NULL,
  `RegulationType` varchar(20) default NULL,
  `RegulatedWaterCategory` varchar(20) default NULL,
  `RegulatedWaterType` varchar(20) default NULL,
  `SectionDes` varchar(255) default NULL,
  `IncludesTribuaryInd` varchar(1) default NULL,
  `StartDate` varchar(10) default NULL,
  `EndDate` varchar(10) default NULL,
  `StartDate2` varchar(10) default NULL,
  `EndDate2` varchar(10) default NULL,
  `StartYear` varchar(10) default NULL,
  `EndYear` varchar(10) default NULL,
  `ActiveInd` varchar(1) default NULL,
  `Robin's Comments` varchar(250) default NULL,
  PRIMARY KEY  (`RegulatedWaterID`),
  KEY `ID` (`RegulatedWaterID`),
  KEY `WaterBodyID` (`WaterBodyID`)
) ENGINE=InnoDB AUTO_INCREMENT=320 DEFAULT CHARSET=utf8;

CREATE TABLE `tblregulatedwaterstretch` (
  `RegWaterStretchID` int(10) NOT NULL auto_increment,
  `RegulatedWaterID` int(10) default NULL,
  `RegulatedWaterName` varchar(50) default NULL,
  `RegulationType` varchar(20) default NULL,
  `RegulatedWaterCategory` varchar(20) default NULL,
  `RegulatedWaterType` varchar(20) default NULL,
  `SectionDesc` varchar(255) default NULL,
  `WaterBodyID` int(10) default NULL,
  `StartRouteMeas` double(15,5) default NULL,
  `EndRouteMeas` double(15,5) default NULL,
  `StreamLength_m` double(15,5) default NULL,
  PRIMARY KEY  (`RegWaterStretchID`),
  KEY `{A1CB7636-57E5-40DC-994A-E5480B` (`WaterBodyID`),
  KEY `{C115ED9E-8DC5-4E4E-9FD3-028E51` (`RegulatedWaterID`),
  KEY `ID` (`RegWaterStretchID`),
  KEY `RegWaterID` (`RegulatedWaterID`),
  KEY `WaterBodyID` (`WaterBodyID`)
) ENGINE=InnoDB AUTO_INCREMENT=320 DEFAULT CHARSET=utf8;

CREATE TABLE `tblrelatedaquaticactivities` (
  `RelatedAquaticActivitiesID` int(10) NOT NULL auto_increment,
  `PrimaryAquaticActivityID` int(10) default NULL,
  `RelatedAquaticActivityID` int(10) default NULL,
  `oldPrimaryAquaticActivityID` int(10) default NULL,
  `oldRelatedAquaticActivityID` int(10) default NULL,
  PRIMARY KEY  (`RelatedAquaticActivitiesID`),
  KEY `AquaticActivityID` (`oldPrimaryAquaticActivityID`),
  KEY `oldRelatedAquaticActivityID` (`oldRelatedAquaticActivityID`),
  KEY `PrimaryAquaticActivityID` (`PrimaryAquaticActivityID`),
  KEY `RelatedAquaticActivityID` (`RelatedAquaticActivitiesID`),
  KEY `RelatedAquaticActivityID1` (`RelatedAquaticActivityID`)
) ENGINE=InnoDB AUTO_INCREMENT=1031 DEFAULT CHARSET=utf8;

CREATE TABLE `tblriversystem` (
  `RiverSystemID` smallint(5) NOT NULL,
  `WaterBodyID` int(10) default NULL,
  `RiverSystemName` varchar(40) default NULL,
  `DrainageCd` varchar(17) default NULL,
  PRIMARY KEY  (`RiverSystemID`),
  KEY `RiverSystemID` (`RiverSystemID`),
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblsample` (
  `SampleID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `LabNo` varchar(10) default NULL,
  `AgencySampleNo` varchar(10) default NULL,
  `SampleDepth_m` double(7,2) default NULL,
  `WaterSourceType` varchar(20) default NULL,
  `SampleCollectionMethodCd` int(10) default NULL,
  `AnalyzedBy` varchar(255) default NULL,
  PRIMARY KEY  (`SampleID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `cdSampleCollectionMethodtblSamp` (`SampleCollectionMethodCd`),
  KEY `tblAquaticActivitytblSample` (`AquaticActivityID`),
  KEY `tblSampleWaterSourceType` (`WaterSourceType`),
  KEY `TempAquaticActivityID` (`TempAquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblsatelliterearing` (
  `AquaticActivityID` int(10) NOT NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `NoTanks` smallint(5) default NULL,
  `AgeClassReceived` varchar(15) default NULL,
  `NoReceived` int(10) default NULL,
  `DateStocked` varchar(10) default NULL,
  `NoStocked` int(10) default NULL,
  PRIMARY KEY  (`AquaticActivityID`),
  KEY `{63E3F53B-740C-4E97-82E7-710E46` (`AquaticActivityID`),
  KEY `{B2F6C32C-EB8E-47D5-ABD1-9D0EB5` (`AgeClassReceived`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblsitemeasurement` (
  `SiteMeasurementID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `OandMCd` int(10) default NULL,
  `OandM_Other` varchar(20) default NULL,
  `Bank` varchar(10) default NULL,
  `InstrumentCd` int(10) default NULL,
  `Measurement` double(15,5) default NULL,
  `UnitofMeasureCd` int(10) default NULL,
  PRIMARY KEY  (`SiteMeasurementID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `SiteMeasurementID` (`SiteMeasurementID`),
  KEY `tblAquaticActivitytblSiteMeasur` (`AquaticActivityID`)
) ENGINE=InnoDB AUTO_INCREMENT=5135 DEFAULT CHARSET=utf8;

CREATE TABLE `tblspawners` (
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `SmallRedds` double(15,5) default NULL,
  `LargeRedds` double(15,5) default NULL,
  `TotalRedds` double(15,5) default NULL,
  `NoGrilse` double(15,5) default NULL,
  `NoMSW` double(15,5) default NULL,
  `TotalASalmon` double(15,5) default NULL,
  `Comments` varchar(150) default NULL,
  KEY `AquaticActivityID1` (`TempAquaticActivityID`),
  KEY `AquaticActivityID2` (`AquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblsportfishinganglinglease` (
  `SportfishingID` int(10) NOT NULL auto_increment,
  `RegulatedWaterID` int(10) default NULL,
  `LeaseNo` smallint(5) default NULL,
  `Year` varchar(4) default NULL,
  `TB_TS_RodDay` double(15,5) default NULL,
  `TB_TS_RodHours` int(10) default NULL,
  `TB_Gr_Harvest` double(15,5) default NULL,
  `TB_Gr_Release` double(15,5) default NULL,
  `TB_Gr_Total` double(15,5) default NULL,
  `TB_MSW_Harvest` double(15,5) default NULL,
  `TB_MSW_Release` double(15,5) default NULL,
  `TB_MSW_Total` double(15,5) default NULL,
  `TB_AS_Harvest` double(15,5) default NULL,
  `TB_AS_Release` double(15,5) default NULL,
  `TB_AS_Total` double(15,5) default NULL,
  `TB_CPU_Grilse` double(15,5) default NULL,
  `TB_CPU_MSW` double(15,5) default NULL,
  `TB_CPU_Total` double(15,5) default NULL,
  `TS_BT_RodDay` double(15,5) default NULL,
  `TS_BT_Harvest` double(15,5) default NULL,
  `TS_BT_Release` double(15,5) default NULL,
  `TS_BT_Total` double(15,5) default NULL,
  `TS_CPU_BrookTrout` double(15,5) default NULL,
  PRIMARY KEY  (`SportfishingID`),
  KEY `{30865C15-4322-4026-86DB-C859C8` (`RegulatedWaterID`),
  KEY `LEASE_ID` (`LeaseNo`),
  KEY `RegulatedWaterID` (`RegulatedWaterID`)
) ENGINE=InnoDB AUTO_INCREMENT=513 DEFAULT CHARSET=utf8;

CREATE TABLE `tblsportfishingatlanticsalmon` (
  `SportfishingID` int(10) NOT NULL auto_increment,
  `WaterBodyID` int(10) default NULL,
  `WaterBodyName` varchar(55) default NULL,
  `DrainageCd` varchar(17) default NULL,
  `Year` varchar(4) default NULL,
  `KT_AS_RodDay` double(15,5) default NULL,
  `KT_Gr_Harvest` double(15,5) default NULL,
  `KT_Gr_Release` double(15,5) default NULL,
  `KT_Gr_Total` double(15,5) default NULL,
  `KT_MSW_Harvest` double(15,5) default NULL,
  `KT_MSW_Release` double(15,5) default NULL,
  `KT_MSW_Total` double(15,5) default NULL,
  `KT_AS_Harvest` double(15,5) default NULL,
  `KT_AS_Release` double(15,5) default NULL,
  `KT_AS_Total` double(15,5) default NULL,
  `KT_CPU_Grilse` double(15,5) default NULL,
  `KT_CPU_MSW` double(15,5) default NULL,
  `KT_CPU_Total` double(15,5) default NULL,
  `KT_CPA_Lwr` double(15,5) default NULL,
  `KT_CPA_Mean` double(15,5) default NULL,
  `KT_CPA_Upr` double(15,5) default NULL,
  `KT_CPA_CV` double(15,5) default NULL,
  `TB_AS_RodDay` double(15,5) default NULL,
  `TB_Gr_Harvest` double(15,5) default NULL,
  `TB_Gr_Release` double(15,5) default NULL,
  `TB_Gr_Total` double(15,5) default NULL,
  `TB_MSW_Harvest` double(15,5) default NULL,
  `TB_MSW_Release` double(15,5) default NULL,
  `TB_MSW_Total` double(15,5) default NULL,
  `TB_AS_Harvest` double(15,5) default NULL,
  `TB_AS_Release` double(15,5) default NULL,
  `TB_AS_Total` double(15,5) default NULL,
  `TB_CPU_Grilse` double(15,5) default NULL,
  `TB_CPU_MSW` double(15,5) default NULL,
  `TB_CPU_Total` double(15,5) default NULL,
  `TB_CPA_Lwr` double(15,5) default NULL,
  `TB_CPA_Mean` double(15,5) default NULL,
  `TB_CPA_Upr` double(15,5) default NULL,
  `TB_CPA_CV` double(15,5) default NULL,
  `EB_AS_RodDay` double(15,5) default NULL,
  `EB_Gr_Harvest` double(15,5) default NULL,
  `EB_Gr_Release` double(15,5) default NULL,
  `EB_Gr_Total` double(15,5) default NULL,
  `EB_MSW_Harvest` double(15,5) default NULL,
  `EB_MSW_Release` double(15,5) default NULL,
  `EB_MSW_Total` double(15,5) default NULL,
  `EB_AS_Harvest` double(15,5) default NULL,
  `EB_AS_Release` double(15,5) default NULL,
  `EB_AS_Total` double(15,5) default NULL,
  `EB_CPU_Grilse` double(15,5) default NULL,
  `EB_CPU_MSW` double(15,5) default NULL,
  `EB_CPU_Total` double(15,5) default NULL,
  `LB_AS_RodDay` double(15,5) default NULL,
  `LB_Gr_Harvest` double(15,5) default NULL,
  `LB_Gr_Release` double(15,5) default NULL,
  `LB_Gr_Total` double(15,5) default NULL,
  `LB_MSW_Harvest` double(15,5) default NULL,
  `LB_MSW_Release` double(15,5) default NULL,
  `LB_MSW_Total` double(15,5) default NULL,
  `LB_AS_Harvest` double(15,5) default NULL,
  `LB_AS_Release` double(15,5) default NULL,
  `LB_AS_Total` double(15,5) default NULL,
  `LB_CPU_Grilse` double(15,5) default NULL,
  `LB_CPU_MSW` double(15,5) default NULL,
  `LB_CPU_Total` double(15,5) default NULL,
  `TS_AS_RodDay` double(15,5) default NULL,
  `TS_Gr_Harvest` double(15,5) default NULL,
  `TS_Gr_Release` double(15,5) default NULL,
  `TS_Gr_Total` double(15,5) default NULL,
  `TS_MSW_Harvest` double(15,5) default NULL,
  `TS_MSW_Release` double(15,5) default NULL,
  `TS_MSW_Total` double(15,5) default NULL,
  `TS_AS_Harvest` double(15,5) default NULL,
  `TS_AS_Release` double(15,5) default NULL,
  `TS_AS_Total` double(15,5) default NULL,
  `TS_CPU_Grilse` double(15,5) default NULL,
  `TS_CPU_MSW` double(15,5) default NULL,
  `TS_CPU_Total` double(15,5) default NULL,
  PRIMARY KEY  (`SportfishingID`),
  KEY `{B2264753-0653-48B6-93B6-759023` (`WaterBodyID`),
  KEY `SportfishingID` (`SportfishingID`),
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB AUTO_INCREMENT=1338 DEFAULT CHARSET=utf8;

CREATE TABLE `tblsportfishingcrownreserve` (
  `SportfishingID` int(10) NOT NULL auto_increment,
  `RegulatedWaterID` int(10) default NULL,
  `Year` varchar(4) default NULL,
  `TB_TS_RodDay` double(15,5) default NULL,
  `TB_Gr_Harvest` double(15,5) default NULL,
  `TB_Gr_Release` double(15,5) default NULL,
  `TB_Gr_Total` double(15,5) default NULL,
  `TB_MSW_Harvest` double(15,5) default NULL,
  `TB_MSW_Release` double(15,5) default NULL,
  `TB_MSW_Total` double(15,5) default NULL,
  `TB_AS_Harvest` double(15,5) default NULL,
  `TB_AS_Release` double(15,5) default NULL,
  `TB_AS_Total` double(15,5) default NULL,
  `TB_CPU_Grilse` double(15,5) default NULL,
  `TB_CPU_MSW` double(15,5) default NULL,
  `TB_CPU_Total` double(15,5) default NULL,
  `TS_BT_Harvest` double(15,5) default NULL,
  `TS_BT_Release` double(15,5) default NULL,
  `TS_BT_Total` double(15,5) default NULL,
  PRIMARY KEY  (`SportfishingID`),
  KEY `{771658EA-10AB-4276-AE7C-A4A7E0` (`RegulatedWaterID`),
  KEY `RegulatedWaterID` (`RegulatedWaterID`),
  KEY `SportfishingID` (`SportfishingID`)
) ENGINE=InnoDB AUTO_INCREMENT=709 DEFAULT CHARSET=utf8;

CREATE TABLE `tblstockedfish` (
  `FishStockingID` int(10) NOT NULL auto_increment,
  `siteuseid` int(10) default NULL,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `FishSpeciesCd` varchar(2) default NULL,
  `FishStockID` int(10) default NULL,
  `OtherStock` varchar(50) default NULL,
  `FishMatingID` int(10) default NULL,
  `FishStrainCd` int(10) default NULL,
  `BroodstockInd` tinyint(1) NOT NULL,
  `FishAge` varchar(10) default NULL,
  `AgeUnitOfMeasure` varchar(10) default NULL,
  `FishAgeClass` varchar(20) default NULL,
  `NoFish` int(10) default NULL,
  `FishFacilityID` int(10) default NULL,
  `OtherFishFacility` varchar(50) default NULL,
  `FishTankNo` varchar(2) default NULL,
  `SatelliteRearedInd` tinyint(1) NOT NULL,
  `AveLength_cm` double(15,5) default NULL,
  `LengthRange_cm` varchar(20) default NULL,
  `FishLengthType` varchar(10) default NULL,
  `AveWeight_gm` double(15,5) default NULL,
  `WeightRange_gm` varchar(20) default NULL,
  `NoFishMeasured` int(10) default NULL,
  `AppliedMarkCd` int(10) default NULL,
  `Source` varchar(50) default NULL,
  PRIMARY KEY  (`FishStockingID`),
  KEY `{42C7EB4F-0D16-4C9E-B72B-E3FAFE` (`FishStockID`),
  KEY `{4664ED76-C4C5-4F01-94C2-787706` (`FishMatingID`),
  KEY `{69365FA7-DC11-4323-8B3A-9B41CC` (`FishSpeciesCd`),
  KEY `{98DE86FF-08D4-4803-B4A0-6BBE0E` (`AppliedMarkCd`),
  KEY `{AA01333A-8722-46C3-8FD4-2BF486` (`FishFacilityID`),
  KEY `{BC3A6A6A-7068-4DFD-8F21-E0E9B8` (`FishAgeClass`),
  KEY `{DA7ACC03-F95D-442C-934E-76D801` (`AquaticActivityID`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`),
  KEY `FishMatingID` (`FishMatingID`),
  KEY `FishRearingFacilID` (`FishFacilityID`),
  KEY `FishStockID` (`FishStockID`),
  KEY `FishStockingID` (`FishStockingID`),
  KEY `siteuseid` (`siteuseid`)
) ENGINE=InnoDB AUTO_INCREMENT=28144 DEFAULT CHARSET=utf8;

CREATE TABLE `tblstreamattribute` (
  `WaterBodyID` int(10) NOT NULL,
  `StreamLength_km` double(15,5) default NULL,
  `HighestOrder` smallint(5) default NULL,
  `IntermittentInd` varchar(1) default NULL,
  `TidalInd` varchar(1) default NULL,
  PRIMARY KEY  (`WaterBodyID`),
  UNIQUE KEY `{A520FBFB-F9B2-44B6-99D7-0C8E1B` (`WaterBodyID`),
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblvibertboxanalysis` (
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `LocationDesc` varchar(20) default NULL,
  `LidDepth_cm` double(15,5) default NULL,
  `WetWeight_Initial_gm` double(15,5) default NULL,
  `WetWeight_Final_gm` double(15,5) default NULL,
  `WetWeight_Net_gm` double(15,5) default NULL,
  `WetWeight_Fines_Percent` double(15,5) default NULL,
  `DryWeight_Total_gm` double(15,5) default NULL,
  `DrytWeight_Box_Rocks_gm` double(15,5) default NULL,
  `DryWeight_Box_Rocks_Percent` double(15,5) default NULL,
  `DryWeight_FineGravel_gm` double(15,5) default NULL,
  `DryWeight_fineGravel_Percent` double(15,5) default NULL,
  `DryWeight_Sand_gm` double(15,5) default NULL,
  `DryWeight_Sand_Percent` double(15,5) default NULL,
  `DryWeight_Fines_gm` double(15,5) default NULL,
  `DryWeight_Fines_Percent` double(15,5) default NULL,
  `Comments` varchar(150) default NULL,
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `oldAquaticActivityID` (`TempAquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblwaterbody` (
  `WaterBodyID` int(10) NOT NULL,
  `DrainageCd` varchar(17) default NULL,
  `WaterBodyTypeCd` varchar(4) default NULL,
  `WaterBodyName` varchar(55) default NULL,
  `WaterBodyName_Abrev` varchar(40) default NULL,
  `WaterBodyName_Alt` varchar(40) default NULL,
  `WaterBodyComplexID` smallint(5) default NULL,
  `Surveyed_Ind` varchar(1) default NULL,
  `FlowsIntoWaterBodyID` double(15,5) default NULL,
  `FlowsIntoWaterBodyName` varchar(40) default NULL,
  `FlowIntoDrainageCd` varchar(17) default NULL,
  `DateEntered` datetime default NULL,
  `DateModified` datetime default NULL,
  PRIMARY KEY  (`WaterBodyID`),
  KEY `{267293E5-26E7-418B-9AFA-318DAE` (`WaterBodyComplexID`),
  KEY `CMPLX_ID` (`WaterBodyComplexID`),
  KEY `DR_CODE` (`DrainageCd`),
  KEY `FLOW_ID` (`FlowsIntoWaterBodyID`),
  KEY `WATER_ID` (`WaterBodyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblwaterbodycomplex` (
  `WaterBodyComplexID` smallint(5) NOT NULL,
  `WaterBodyComplexName` varchar(55) default NULL,
  `WaterBodyComplexType` varchar(4) default NULL,
  `DrainageCd` varchar(17) default NULL,
  PRIMARY KEY  (`WaterBodyComplexID`),
  KEY `CMPLX_ID` (`WaterBodyComplexID`),
  KEY `tblWaterBodyComplexesDrainageCd` (`DrainageCd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblwaterchemistryanalysis` (
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `DOE_Program` varchar(14) default NULL,
  `DOE_ProjectNo` varchar(10) default NULL,
  `DOE_StationNo` varchar(15) default NULL,
  `DOE_LabNo` varchar(8) default NULL,
  `DOE_FieldNo` varchar(11) default NULL,
  `SecchiDepth_m` double(15,5) default NULL,
  `SampleDepth_m` double(15,5) default NULL,
  `WaterTemp_C` double(15,5) default NULL,
  `DO` double(15,5) default NULL,
  `TOXIC_UNIT` double(15,5) default NULL,
  `L_HARD` varchar(1) default NULL,
  `HARD` double(15,5) default NULL,
  `NO3` double(15,5) default NULL,
  `L_AL_X` varchar(1) default NULL,
  `AL_X` double(15,5) default NULL,
  `L_AL_XGF` varchar(1) default NULL,
  `AL_XGF` double(15,5) default NULL,
  `L_ALK_G` varchar(1) default NULL,
  `ALK_G` double(15,5) default NULL,
  `L_ALK_P` varchar(1) default NULL,
  `ALK_P` double(15,5) default NULL,
  `L_ALK_T` varchar(1) default NULL,
  `ALK_T` double(15,5) default NULL,
  `L_AS_XGF` varchar(1) default NULL,
  `AS_XGF` double(15,5) default NULL,
  `L_BA_X` varchar(1) default NULL,
  `BA_X` double(15,5) default NULL,
  `L_B_X` varchar(1) default NULL,
  `B_X` double(15,5) default NULL,
  `L_BR` varchar(1) default NULL,
  `BR` double(15,5) default NULL,
  `L_CA_D` varchar(1) default NULL,
  `CA_D` double(15,5) default NULL,
  `L_CD_XGF` varchar(1) default NULL,
  `CD_XGF` double(15,5) default NULL,
  `L_CHL_A` varchar(1) default NULL,
  `CHL_A` double(15,5) default NULL,
  `L_CL` varchar(1) default NULL,
  `CL` double(15,5) default NULL,
  `L_CL_IC` varchar(1) default NULL,
  `CL_IC` double(15,5) default NULL,
  `L_CLRA` varchar(1) default NULL,
  `CLRA` double(15,5) default NULL,
  `L_CO_X` varchar(1) default NULL,
  `CO_X` double(15,5) default NULL,
  `L_COND` varchar(1) default NULL,
  `COND` double(15,5) default NULL,
  `COND2` double(15,5) default NULL,
  `L_CR_X` varchar(1) default NULL,
  `CR_X` double(15,5) default NULL,
  `L_CR_XGF` varchar(1) default NULL,
  `CR_XGF` double(15,5) default NULL,
  `L_CU_X` varchar(1) default NULL,
  `CU_X` double(15,5) default NULL,
  `L_CU_XGF` varchar(1) default NULL,
  `CU_XGF` double(15,5) default NULL,
  `L_DOC` varchar(1) default NULL,
  `DOC` double(15,5) default NULL,
  `L_F` varchar(1) default NULL,
  `F` double(15,5) default NULL,
  `L_FE_X` varchar(1) default NULL,
  `FE_X` double(15,5) default NULL,
  `L_HG_T` varchar(1) default NULL,
  `HG_T` double(15,5) default NULL,
  `L_K` varchar(1) default NULL,
  `K` double(15,5) default NULL,
  `L_MG_D` varchar(1) default NULL,
  `MG_D` double(15,5) default NULL,
  `L_MN_X` varchar(1) default NULL,
  `MN_X` double(15,5) default NULL,
  `L_NA` varchar(1) default NULL,
  `NA` double(15,5) default NULL,
  `L_NH3T` varchar(1) default NULL,
  `NH3T` double(15,5) default NULL,
  `L_NI_X` varchar(1) default NULL,
  `NI_X` double(15,5) default NULL,
  `L_NO2D` varchar(1) default NULL,
  `NO2D` double(15,5) default NULL,
  `L_NOX` varchar(1) default NULL,
  `NOX` double(15,5) default NULL,
  `L_PB_XGF` varchar(1) default NULL,
  `PB_XGF` double(15,5) default NULL,
  `L_PH` varchar(1) default NULL,
  `PH` double(15,5) default NULL,
  `L_PH_GAL` varchar(1) default NULL,
  `PH_GAL` double(15,5) default NULL,
  `L_SB_XGF` varchar(1) default NULL,
  `SB_XGF` double(15,5) default NULL,
  `L_SE_XGF` varchar(1) default NULL,
  `SE_XGF` double(15,5) default NULL,
  `SILICA` double(15,5) default NULL,
  `L_SO4` varchar(1) default NULL,
  `SO4` double(15,5) default NULL,
  `L_SO4_IC` varchar(1) default NULL,
  `SO4_IC` double(15,5) default NULL,
  `L_SS` varchar(1) default NULL,
  `SS` double(15,5) default NULL,
  `L_TDS` varchar(1) default NULL,
  `TDS` double(15,5) default NULL,
  `L_TKN` varchar(1) default NULL,
  `TKN` double(15,5) default NULL,
  `L_TL_XGF` varchar(1) default NULL,
  `TL_XGF` double(15,5) default NULL,
  `L_TOC` varchar(1) default NULL,
  `TOC` double(15,5) default NULL,
  `L_TP_L` varchar(1) default NULL,
  `TP_L` double(15,5) default NULL,
  `L_TURB` varchar(1) default NULL,
  `TURB` double(15,5) default NULL,
  `L_ZN_X` varchar(1) default NULL,
  `ZN_X` double(15,5) default NULL,
  `L_ZN_XGF` varchar(1) default NULL,
  `ZN_XGF` double(15,5) default NULL,
  `L_O_PHOS` varchar(1) default NULL,
  `O_PHOS` double(15,5) default NULL,
  `BICARB` double(15,5) default NULL,
  `CARB` double(15,5) default NULL,
  `SAT_PH` double(15,5) default NULL,
  `SAT_NDX` double(15,5) default NULL,
  KEY `{A84E8104-E838-4C00-8C7A-E4A3D7` (`AquaticActivityID`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `tblwatermeasurement` (
  `WaterMeasurementID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `TempAquaticActivityID` int(10) default NULL,
  `TempDataID` int(10) default NULL,
  `TemperatureLoggerID` int(10) default NULL,
  `HabitatUnitID` int(10) default NULL,
  `SampleID` int(10) default NULL,
  `WaterSourceCd` varchar(50) default NULL,
  `WaterDepth_m` double(7,2) default NULL,
  `TimeofDay` varchar(5) default NULL,
  `OandMCd` int(10) default NULL,
  `InstrumentCd` int(10) default NULL,
  `Measurement` double(7,2) default NULL,
  `UnitofMeasureCd` int(10) default NULL,
  `QualifierCd` varchar(20) default NULL,
  `Comment` varchar(255) default NULL,
  PRIMARY KEY  (`WaterMeasurementID`),
  KEY `AquaticActivityID` (`TempAquaticActivityID`),
  KEY `AquaticActivityID1` (`AquaticActivityID`),
  KEY `cdInstrumenttblWaterMeasurement` (`InstrumentCd`),
  KEY `cdOandMtblWaterMeasurement` (`OandMCd`),
  KEY `cdUnitofMeasuretblWaterMeasurem` (`UnitofMeasureCd`),
  KEY `cdWaterSourcetblWaterMeasurement` (`WaterSourceCd`),
  KEY `SampleID` (`SampleID`),
  KEY `tblAquaticActivitytblWaterMeasu` (`AquaticActivityID`),
  KEY `tblWaterMeasurementQualifierCd` (`QualifierCd`),
  KEY `TempDataID` (`TempDataID`),
  KEY `TemperatureLoggerID` (`TemperatureLoggerID`),
  KEY `WaterMeasurementID` (`WaterMeasurementID`)
) ENGINE=InnoDB AUTO_INCREMENT=194944 DEFAULT CHARSET=utf8;

CREATE TABLE `tblwatertemperatureloggerdetails` (
  `TemperatureLoggerID` int(10) NOT NULL auto_increment,
  `AquaticActivityID` int(10) default NULL,
  `LoggerNo` varchar(20) default NULL,
  `BrandName` varchar(30) default NULL,
  `Model` varchar(20) default NULL,
  `Resolution` varchar(20) default NULL,
  `Accuracy` varchar(20) default NULL,
  `TempRange_From` int(10) default NULL,
  `TempRange_To` int(10) default NULL,
  `DataFileName` varchar(75) default NULL,
  `InstallationDate` varchar(10) default NULL,
  `RemovalDate` varchar(10) default NULL,
  `RecordingStartDate` varchar(10) default NULL,
  `RecordingEndDate` varchar(10) default NULL,
  `OutofWaterReadingsOccurred` tinyint(1) NOT NULL,
  `OutofWaterReadingsRemoved` tinyint(1) NOT NULL,
  `DistanceFromLeftBank_m` int(10) default NULL,
  `DistanceFromRightBank_m` int(10) default NULL,
  `WaterDepth_cm` int(10) default NULL,
  `SampleInterval_min` double(7,2) default NULL,
  `Install_WaterTemp_C` double(7,2) default NULL,
  `Install_AirTemp_C` double(7,2) default NULL,
  `Install_TimeofDay` varchar(5) default NULL,
  `Removal_WaterTemp_C` double(7,2) default NULL,
  `Removal_AirTemp_C` double(7,2) default NULL,
  `Removal_TimeofDay` varchar(5) default NULL,
  `WaterLevel_Install` varchar(10) default NULL,
  `WaterLevel_Removal` varchar(10) default NULL,
  `DateEntered` datetime default NULL,
  `IncorporatedInd` tinyint(1) NOT NULL,
  PRIMARY KEY  (`TemperatureLoggerID`),
  UNIQUE KEY `TemperatureLoggerID` (`TemperatureLoggerID`),
  KEY `AquaticActivityID` (`AquaticActivityID`),
  KEY `LoggerID` (`LoggerNo`)
) ENGINE=InnoDB AUTO_INCREMENT=291 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');