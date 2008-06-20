CREATE TABLE `cdagency` (
  `agencycd` varchar(10) NOT NULL,
  `agency` varchar(120) default NULL,
  `agencytype` varchar(8) default NULL,
  `datarulesind` varchar(2) default NULL,
  PRIMARY KEY  (`agencycd`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `cdaquaticactivity` (
  `aquaticactivitycd` int(11) NOT NULL auto_increment,
  `aquaticactivity` varchar(100) default NULL,
  `aquaticactivitycategory` varchar(60) default NULL,
  `duration` varchar(40) default NULL,
  PRIMARY KEY  (`aquaticactivitycd`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

CREATE TABLE `cdaquaticactivitymethod` (
  `aquaticmethodcd` int(11) NOT NULL auto_increment,
  `aquaticactivitycd` int(11) default NULL,
  `aquaticmethod` varchar(60) default NULL,
  PRIMARY KEY  (`aquaticmethodcd`),
  KEY `index_cdAquaticActivityMethod_on_aquaticactivitycd` (`aquaticactivitycd`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;

CREATE TABLE `cdinstrument` (
  `instrumentcd` int(11) NOT NULL auto_increment,
  `instrument` varchar(100) default NULL,
  `instrument_category` varchar(100) default NULL,
  PRIMARY KEY  (`instrumentcd`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

CREATE TABLE `cdmeasureinstrument` (
  `measureinstrumentcd` int(11) NOT NULL auto_increment,
  `oandmcd` int(11) default NULL,
  `instrumentcd` int(11) default NULL,
  PRIMARY KEY  (`measureinstrumentcd`),
  KEY `index_cdMeasureInstrument_on_oandmcd` (`oandmcd`),
  KEY `index_cdMeasureInstrument_on_instrumentcd` (`instrumentcd`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;

CREATE TABLE `cdmeasureunit` (
  `measureunitcd` int(11) NOT NULL auto_increment,
  `oandmcd` int(11) default NULL,
  `unitofmeasurecd` int(11) default NULL,
  PRIMARY KEY  (`measureunitcd`),
  KEY `index_cdMeasureUnit_on_oandmcd` (`oandmcd`),
  KEY `index_cdMeasureUnit_on_unitofmeasurecd` (`unitofmeasurecd`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;

CREATE TABLE `cdoandm` (
  `oandmcd` int(11) NOT NULL auto_increment,
  `oandm_type` varchar(32) default NULL,
  `oandm_category` varchar(80) default NULL,
  `oandm_group` varchar(100) default NULL,
  `oandm_parameter` varchar(100) default NULL,
  `oandm_parametercd` varchar(60) default NULL,
  `oandm_valuesind` tinyint(1) NOT NULL,
  PRIMARY KEY  (`oandmcd`)
) ENGINE=InnoDB AUTO_INCREMENT=104 DEFAULT CHARSET=latin1;

CREATE TABLE `cdoandmvalues` (
  `oandmvaluescd` int(11) NOT NULL auto_increment,
  `oandmcd` int(11) default NULL,
  `value` varchar(40) default NULL,
  PRIMARY KEY  (`oandmvaluescd`),
  KEY `index_cdOandMValues_on_oandmcd` (`oandmcd`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

CREATE TABLE `cdunitofmeasure` (
  `unitofmeasurecd` int(11) NOT NULL auto_increment,
  `unitofmeasure` varchar(100) default NULL,
  `unitofmeasureabv` varchar(20) default NULL,
  PRIMARY KEY  (`unitofmeasurecd`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

CREATE TABLE `parameters` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `code` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=latin1;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `rolename` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

CREATE TABLE `sample_results` (
  `id` int(11) NOT NULL auto_increment,
  `sample_id` int(11) NOT NULL,
  `parameter_id` int(11) NOT NULL,
  `value` float default NULL,
  `qualifier` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14069 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `tblaquaticactivity` (
  `aquaticactivityid` int(11) NOT NULL auto_increment,
  `tempaquaticactivityid` int(11) default NULL,
  `project` varchar(200) default NULL,
  `permitno` varchar(40) default NULL,
  `aquaticprogramid` int(11) default NULL,
  `aquaticactivitycd` int(11) default NULL,
  `aquaticmethodcd` int(11) default NULL,
  `oldaquaticsiteid` int(11) default NULL,
  `aquaticsiteid` int(11) default NULL,
  `aquaticactivitystartdate` varchar(20) default NULL,
  `aquaticactivityenddate` varchar(20) default NULL,
  `aquaticactivitystarttime` varchar(12) default NULL,
  `aquaticactivityendtime` varchar(12) default NULL,
  `year` varchar(8) default NULL,
  `agencycd` varchar(8) default NULL,
  `agency2cd` varchar(8) default NULL,
  `agency2contact` varchar(100) default NULL,
  `aquaticactivityleader` varchar(100) default NULL,
  `crew` varchar(100) default NULL,
  `weatherconditions` varchar(100) default NULL,
  `watertemp_c` float default NULL,
  `airtemp_c` float default NULL,
  `waterlevel` varchar(12) default NULL,
  `waterlevel_cm` varchar(100) default NULL,
  `waterlevel_am_cm` varchar(100) default NULL,
  `waterlevel_pm_cm` varchar(100) default NULL,
  `siltation` varchar(100) default NULL,
  `primaryactivityind` tinyint(1) default NULL,
  `comments` varchar(500) default NULL,
  `dateentered` datetime default NULL,
  `incorporatedind` tinyint(1) default NULL,
  `datetransferred` datetime default NULL,
  `rainfall_last24` varchar(255) default NULL,
  PRIMARY KEY  (`aquaticactivityid`),
  KEY `index_tblAquaticActivity_on_aquaticprogramid` (`aquaticprogramid`),
  KEY `index_tblAquaticActivity_on_aquaticactivitycd` (`aquaticactivitycd`),
  KEY `index_tblAquaticActivity_on_aquaticmethodcd` (`aquaticmethodcd`),
  KEY `index_tblAquaticActivity_on_oldaquaticsiteid` (`oldaquaticsiteid`),
  KEY `index_tblAquaticActivity_on_aquaticsiteid` (`aquaticsiteid`),
  KEY `index_tblAquaticActivity_on_agencycd` (`agencycd`),
  KEY `index_tblAquaticActivity_on_agency2cd` (`agency2cd`)
) ENGINE=InnoDB AUTO_INCREMENT=150639 DEFAULT CHARSET=latin1;

CREATE TABLE `tblaquaticsite` (
  `aquaticsiteid` int(11) NOT NULL auto_increment,
  `oldaquaticsiteid` int(11) default NULL,
  `riversystemid` int(11) default NULL,
  `waterbodyid` int(11) default NULL,
  `waterbodyname` varchar(100) default NULL,
  `aquaticsitename` varchar(200) default NULL,
  `aquaticsitedesc` varchar(500) default NULL,
  `habitatdesc` varchar(100) default NULL,
  `reachno` int(11) default NULL,
  `startdesc` varchar(200) default NULL,
  `enddesc` varchar(200) default NULL,
  `startroutemeas` float default NULL,
  `endroutemeas` float default NULL,
  `sitetype` varchar(40) default NULL,
  `specificsiteind` varchar(2) default NULL,
  `georeferencedind` varchar(2) default NULL,
  `dateentered` datetime default NULL,
  `incorporatedind` tinyint(1) default NULL,
  `coordinatesource` varchar(100) default NULL,
  `coordinatesystem` varchar(100) default NULL,
  `xcoordinate` varchar(100) default NULL,
  `ycoordinate` varchar(100) default NULL,
  `coordinateunits` varchar(100) default NULL,
  `comments` varchar(300) default NULL,
  `wgs84_lat` decimal(15,10) default NULL,
  `wgs84_lon` decimal(15,10) default NULL,
  PRIMARY KEY  (`aquaticsiteid`),
  KEY `index_tblAquaticSite_on_riversystemid` (`riversystemid`),
  KEY `index_tblAquaticSite_on_waterbodyid` (`waterbodyid`)
) ENGINE=InnoDB AUTO_INCREMENT=10000 DEFAULT CHARSET=latin1;

CREATE TABLE `tblaquaticsiteagencyuse` (
  `aquaticsiteuseid` int(11) NOT NULL auto_increment,
  `aquaticsiteid` int(11) default NULL,
  `aquaticactivitycd` int(11) default NULL,
  `aquaticsitetype` varchar(60) default NULL,
  `agencycd` varchar(8) default NULL,
  `agencysiteid` varchar(32) default NULL,
  `startyear` varchar(8) default NULL,
  `endyear` varchar(8) default NULL,
  `yearsactive` varchar(40) default NULL,
  `incorporatedind` tinyint(1) default NULL,
  PRIMARY KEY  (`aquaticsiteuseid`),
  KEY `index_tblAquaticSiteAgencyUse_on_aquaticsiteid` (`aquaticsiteid`),
  KEY `index_tblAquaticSiteAgencyUse_on_aquaticactivitycd` (`aquaticactivitycd`),
  KEY `index_tblAquaticSiteAgencyUse_on_agencycd` (`agencycd`)
) ENGINE=InnoDB AUTO_INCREMENT=6198 DEFAULT CHARSET=latin1;

CREATE TABLE `tblenvironmentalobservations` (
  `envobservationid` int(11) NOT NULL auto_increment,
  `aquaticactivityid` int(11) default NULL,
  `observationgroup` varchar(100) default NULL,
  `observation` varchar(100) default NULL,
  `observationsupp` varchar(100) default NULL,
  `pipesize_cm` int(11) default NULL,
  `fishpassageobstructionind` tinyint(1) default NULL,
  PRIMARY KEY  (`envobservationid`),
  KEY `index_tblEnvironmentalObservations_on_aquaticactivityid` (`aquaticactivityid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblobservations` (
  `observationid` int(11) NOT NULL auto_increment,
  `aquaticactivityid` int(11) default NULL,
  `oandmcd` int(11) default NULL,
  `oandm_other` varchar(50) default NULL,
  `oandmvaluescd` varchar(255) default NULL,
  `pipesize_cm` int(11) default NULL,
  `fishpassageobstructionind` tinyint(1) default NULL,
  PRIMARY KEY  (`observationid`),
  KEY `index_tblObservations_on_aquaticactivityid` (`aquaticactivityid`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

CREATE TABLE `tblsample` (
  `sampleid` int(11) NOT NULL auto_increment,
  `aquaticactivityid` int(11) default NULL,
  `tempaquaticactivityid` int(11) default NULL,
  `agencysampleno` varchar(20) default NULL,
  `sampledepth_m` float default NULL,
  `watersourcetype` varchar(40) default NULL,
  `samplecollectionmethodcd` varchar(255) default NULL,
  `analyzedby` varchar(510) default NULL,
  PRIMARY KEY  (`sampleid`),
  KEY `index_tblSample_on_aquaticactivityid` (`aquaticactivityid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `tblsitemeasurement` (
  `sitemeasurementid` int(11) NOT NULL auto_increment,
  `aquaticactivityid` int(11) default NULL,
  `oandmcd` int(11) default NULL,
  `oandm_other` varchar(255) default NULL,
  `bank` varchar(255) default NULL,
  `instrumentcd` int(11) default NULL,
  `measurement` decimal(10,0) default NULL,
  `unitofmeasurecd` int(11) default NULL,
  PRIMARY KEY  (`sitemeasurementid`),
  KEY `index_tblSiteMeasurement_on_aquaticactivityid` (`aquaticactivityid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tblwaterbody` (
  `waterbodyid` int(11) NOT NULL auto_increment,
  `cgndb_key` varchar(20) default NULL,
  `cgndb_key_alt` varchar(20) default NULL,
  `drainagecd` varchar(34) default NULL,
  `waterbodytypecd` varchar(8) default NULL,
  `waterbodyname` varchar(110) default NULL,
  `waterbodyname_abrev` varchar(80) default NULL,
  `waterbodyname_alt` varchar(80) default NULL,
  `waterbodycomplexid` int(11) default NULL,
  `surveyed_ind` varchar(2) default NULL,
  `flowsintowaterbodyid` float default NULL,
  `flowsintowaterbodyname` varchar(80) default NULL,
  `flowintodrainagecd` varchar(34) default NULL,
  `dateentered` datetime default NULL,
  `datemodified` datetime default NULL,
  PRIMARY KEY  (`waterbodyid`)
) ENGINE=InnoDB AUTO_INCREMENT=1000000 DEFAULT CHARSET=latin1;

CREATE TABLE `tblwatermeasurement` (
  `watermeasurementid` int(11) NOT NULL auto_increment,
  `aquaticactivityid` int(11) default NULL,
  `tempaquaticactivityid` int(11) default NULL,
  `tempdataid` int(11) default NULL,
  `temperatureloggerid` int(11) default NULL,
  `habitatunitid` int(11) default NULL,
  `sampleid` int(11) default NULL,
  `watersourcetype` varchar(100) default NULL,
  `waterdepth_m` float default NULL,
  `timeofday` varchar(10) default NULL,
  `oandmcd` int(11) default NULL,
  `instrumentcd` int(11) default NULL,
  `measurement` float default NULL,
  `unitofmeasurecd` int(11) default NULL,
  `detectionlimitind` tinyint(1) NOT NULL,
  `comment` varchar(510) default NULL,
  PRIMARY KEY  (`watermeasurementid`),
  KEY `index_tblWaterMeasurement_on_aquaticactivityid` (`aquaticactivityid`),
  KEY `index_tblWaterMeasurement_on_tempaquaticactivityid` (`tempaquaticactivityid`),
  KEY `index_tblWaterMeasurement_on_tempdataid` (`tempdataid`),
  KEY `index_tblWaterMeasurement_on_temperatureloggerid` (`temperatureloggerid`),
  KEY `index_tblWaterMeasurement_on_habitatunitid` (`habitatunitid`),
  KEY `index_tblWaterMeasurement_on_sampleid` (`sampleid`),
  KEY `index_tblWaterMeasurement_on_oandmcd` (`oandmcd`),
  KEY `index_tblWaterMeasurement_on_instrumentcd` (`instrumentcd`),
  KEY `index_tblWaterMeasurement_on_unitofmeasurecd` (`unitofmeasurecd`)
) ENGINE=InnoDB AUTO_INCREMENT=194944 DEFAULT CHARSET=latin1;

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
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `agency_code` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (version) VALUES (28)