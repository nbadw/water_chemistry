CREATE TABLE `activities` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `desc` text,
  `category` varchar(255) NOT NULL,
  `duration` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `activity_events` (
  `id` int(11) NOT NULL auto_increment,
  `project` varchar(255) default NULL,
  `permit_number` varchar(255) default NULL,
  `aquatic_program_id` int(11) default NULL,
  `aquatic_activity_code` int(11) default NULL,
  `aquatic_method_code` int(11) default NULL,
  `old_aquatic_site_id` int(11) default NULL,
  `aquatic_site_id` int(11) default NULL,
  `starts_at` datetime default NULL,
  `ends_at` datetime default NULL,
  `agency_code` varchar(255) default NULL,
  `agency2_code` varchar(255) default NULL,
  `agency2_contact` varchar(255) default NULL,
  `aquatic_activity_leader` varchar(255) default NULL,
  `crew` varchar(255) default NULL,
  `weather_conditions` varchar(255) default NULL,
  `water_temp_in_celsius` decimal(10,0) default NULL,
  `air_temp_in_celsius` decimal(10,0) default NULL,
  `water_level` varchar(255) default NULL,
  `water_level_in_cm` varchar(255) default NULL,
  `morning_water_level_in_cm` varchar(255) default NULL,
  `evening_water_level_in_cm` varchar(255) default NULL,
  `siltation` varchar(255) default NULL,
  `primary_activity` tinyint(1) default NULL,
  `comments` varchar(255) default NULL,
  `entered_at` datetime default NULL,
  `incorporated_at` datetime default NULL,
  `transferred_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_activity_events_on_aquatic_program_id` (`aquatic_program_id`),
  KEY `index_activity_events_on_aquatic_activity_code` (`aquatic_activity_code`),
  KEY `index_activity_events_on_aquatic_method_code` (`aquatic_method_code`),
  KEY `index_activity_events_on_aquatic_site_id` (`aquatic_site_id`),
  KEY `index_activity_events_on_agency_code` (`agency_code`),
  KEY `index_activity_events_on_agency2_code` (`agency2_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `agencies` (
  `code` varchar(10) NOT NULL,
  `name` varchar(255) default NULL,
  `agency_type` varchar(255) default NULL,
  `data_rules` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `aquatic_site_usages` (
  `id` int(11) NOT NULL auto_increment,
  `aquatic_site_id` int(11) default NULL,
  `aquatic_activity_code` int(11) default NULL,
  `aquatic_site_type` varchar(255) default NULL,
  `agency_code` varchar(255) default NULL,
  `agency_site_id` varchar(255) default NULL,
  `start_year` varchar(255) default NULL,
  `end_year` varchar(255) default NULL,
  `years_active` varchar(255) default NULL,
  `incorporated_at` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `aquatic_site_id` (`aquatic_site_id`),
  KEY `aquatic_activity_code` (`aquatic_activity_code`),
  KEY `agency_code` (`agency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `aquatic_sites` (
  `id` int(11) NOT NULL auto_increment,
  `old_aquatic_site_id` int(11) default NULL,
  `river_system_id` int(11) default NULL,
  `waterbody_id` int(11) default NULL,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `habitat_desc` varchar(255) default NULL,
  `reach_no` int(11) default NULL,
  `start_desc` varchar(255) default NULL,
  `end_desc` varchar(255) default NULL,
  `start_route_meas` float default NULL,
  `end_route_meas` float default NULL,
  `site_type` varchar(255) default NULL,
  `specific_site` tinyint(1) default NULL,
  `georeferenced` tinyint(1) default NULL,
  `entered_at` datetime default NULL,
  `incorporated_at` datetime default NULL,
  `coordinate_source` varchar(255) default NULL,
  `coordinate_system` varchar(255) default NULL,
  `coordinate_units` varchar(255) default NULL,
  `x_coord` varchar(255) default NULL,
  `y_coord` varchar(255) default NULL,
  `comments` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `deleted_at` datetime default NULL,
  `wgs84_lat` decimal(15,10) default NULL,
  `wgs84_lon` decimal(15,10) default NULL,
  PRIMARY KEY  (`id`),
  KEY `waterbody_id` (`waterbody_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `instruments` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `category` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `lab_types` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `measurement_units` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `symbol` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL auto_increment,
  `role_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
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

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

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
  PRIMARY KEY  (`id`),
  KEY `agency_code` (`agency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `waterbodies` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `abbrev_name` varchar(255) default NULL,
  `alt_name` varchar(255) default NULL,
  `drainage_code` varchar(255) default NULL,
  `waterbody_type` varchar(255) default NULL,
  `waterbody_complex_id` int(11) default NULL,
  `surveyed` tinyint(1) default NULL,
  `flows_into_waterbody_id` int(11) default NULL,
  `flows_into_waterbody_name` varchar(255) default NULL,
  `flows_into_watershed` varchar(255) default NULL,
  `date_entered` datetime default NULL,
  `date_modified` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `drainage_code` (`drainage_code`),
  KEY `flows_into_waterbody_id` (`flows_into_waterbody_id`),
  KEY `flows_into_watershed` (`flows_into_watershed`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `watersheds` (
  `drainage_code` varchar(17) NOT NULL,
  `name` varchar(255) default NULL,
  `unit_type` varchar(255) default NULL,
  `border` tinyint(1) default NULL,
  `stream_order` int(11) default NULL,
  `area_ha` float default NULL,
  `area_percent` float default NULL,
  `drains_into` varchar(255) default NULL,
  `level1_no` varchar(255) default NULL,
  `level1_name` varchar(255) default NULL,
  `level2_no` varchar(255) default NULL,
  `level2_name` varchar(255) default NULL,
  `level3_no` varchar(255) default NULL,
  `level3_name` varchar(255) default NULL,
  `level4_no` varchar(255) default NULL,
  `level4_name` varchar(255) default NULL,
  `level5_no` varchar(255) default NULL,
  `level5_name` varchar(255) default NULL,
  `level6_no` varchar(255) default NULL,
  `level6_name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`drainage_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `schema_info` (version) VALUES (16)