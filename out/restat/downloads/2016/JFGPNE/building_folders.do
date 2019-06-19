#delimit;
set logtype text;

** REPLACE FILE PATH WITH PATH TO RELEVANT REPLICATION FILES;
local fileloc = "~/KMS_REPLICATION";

set more off;
clear all;

** FOLDER CONSTRUCTION;
** Building all folders contained within "REPLICATION" for the purpose of data storage, etc. Perform this activity first;

** Data storage;
	shell mkdir `fileloc'/data;
	shell mkdir `fileloc'/data/birth_data;
		shell mkdir `fileloc'/data/birth_data/raw_data/2002;
		shell mkdir `fileloc'/data/birth_data/raw_data/2003;
		shell mkdir `fileloc'/data/birth_data/raw_data/2004;
		shell mkdir `fileloc'/data/birth_data/raw_data/2005;
		shell mkdir `fileloc'/data/birth_data/raw_data/2006;
	shell mkdir `fileloc'/data/emissions_data;
	shell mkdir `fileloc'/data/location_data;
	shell mkdir `fileloc'/data/traffic_data;
		shell mkdir `fileloc'/data/traffic_data/dta_files;
		shell mkdir `fileloc'/data/traffic_data/text_data;
	shell mkdir `fileloc'/data/weather_data;
	shell mkdir `fileloc'/simulation;
	shell mkdir `fileloc'/dicts;

** Output;
	shell mkdir `fileloc'/regs;
	shell mkdir `fileloc'/graphs;
	shell mkdir `fileloc'/log_files;
