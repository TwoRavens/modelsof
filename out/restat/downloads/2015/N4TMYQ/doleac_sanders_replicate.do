#delimit;
clear all;
set more off;
set matsize 10000;
set maxvar 20000;
set logtype text;
local fileloc = "~/Replication/daylight_savings_crime/Replication";
capture log close;
log using doleac_sanders_replicate.txt, replace;


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX NOTES XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

** Locals and globals below establish the look of graphs, estout tables, and which parts of the program to execute in any given run. The do-file assumes you have estout installed.

** For ease of replication, place all downloaded data sets and the do-file in a folder named "Replication". Generate three new folders for output and data storage, named "data", "figures", and "regs". The do-file will access these folders as part of the replication process. Place all downloaded data in the "data" folder.

** Replace the local "fileloc" above with the directory to the folder on your machine containing the "Replication" folder. 


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX GLOBALS XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

global graph_options "graphregion(fcolor(white) color(white) icolor(white)) plotregion()";

global esttab_opts "b(%9.3f) se sfmt(%9.3f) starlevels(* 0.10 ** 0.05 *** 0.01) nogaps staraux r2";

**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX locals XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

** DATA BUILDING – set to 1 to run different data set construction steps;
local location = 0;
local timezones = 0;
local time = 0;
local hourly = 0;
local basedata = 0;
local rebuild = 0;

** WEATHER – set "add_weather" to 1 to add data, and turn off comment on local "weather" to run regressions with weather added. Replace local "weather_location" with the location of the weather data, and name variables "avg_temp" for temperature and "prec" for rainfall;
local add_weather = 0;
**local weather = "avg_temp prec";
**local weather_location = ;

** Locals for the beginning and end of DST in each year;
local dst2005 = td(03Apr2005);
local dst2006 = td(02Apr2006);
local dst2007 = td(11Mar2007);
local dst2008 = td(09Mar2008);

local laterdst2005 = td(30Oct2005);
local laterdst2006 = td(29Oct2006);
local laterdst2007 = td(04Nov2007);
local laterdst2008 = td(02Nov2008);


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - TIME XXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

if `timezones' == 1 {;

	** Timezone data by county are from http://www.nws.noaa.gov/geodata/catalog/wsom/html/cntyzone.htm;
	
	insheet using `fileloc'/data/fips_timezones.csv, clear;
	rename v7 fips;
	rename v8 zone;
	keep fips zone;
	destring fips, replace force;
	
	** Replace weird time zones;
	replace zone = "C" if zone == "CE";
	replace zone = "C" if zone == "CM";
	replace zone = "M" if zone == "MC";
	replace zone = "M" if zone == "MP";
	keep if zone == "E" | zone == "C" | zone == "M" | zone == "P"; 
	tab zone;

	bysort fips: keep if _n == 1;
	tab zone;
	
	sort fips;
	save `fileloc'/data/fips_to_timezone.dta, replace;

};


if `location' == 1 {;

	** Stata version of crosswalk available here http://www.icpsr.umich.edu/icpsrweb/ICPSR/studies/4634;
	use `fileloc'/data/crosswalk_stata_version.dta, clear;
	gen fips = FSTATE*1000 + FCOUNTY;
	drop FSTATE FCOUNTY;
		
	** Keep only major gov't region codes;
	keep if CLASSCD == "C1" | CLASSCD == "C5" | CLASSCD == "H1" | CLASSCD == "T1";
	rename LAT latitude;
	rename LONG longitude;
	rename ORI9 ori;
	** Clean data and keep variables you want;
	keep latitude longitude AGENTYPE fips ori;	
	** Keep only the "normal" regions: sheriff, county, and municipal only;
	keep if AGENTYPE == 1 | AGENTYPE == 2 | AGENTYPE == 3;
	
	sort fips;

	tempfile location;
	save `location';
	use `fileloc'/data/fips_to_timezone.dta, clear;
	sort fips;
	merge fips using `location';
	tab _merge;
	keep if _merge == 3;
	drop _merge;	
	
	sort ori;
	compress;

	** Drop those with missing origin location;
	drop if ori == "";
		
	save `fileloc'/data/ori_lat_long_new.dta, replace;	

};


if `time' == 1 {;
	
	** Latitude and longitude-based sunset times derived from http://www.esrl.noaa.gov/gmd/grad/solcalc/;
		
	use `fileloc'/data/latlong_sunrise.dta, clear;
	keep if year >= 2005 & year <= 2008;
	sort latitude longitude;
		
	tempfile latlong;
	save `latlong';
	use `fileloc'/data/ori_lat_long_new.dta, clear;

	sort latitude longitude;
	joinby latitude longitude using `latlong';
	
	gen state = substr(ori,1,2);
	** Drop Alaska and Indiana;
	drop if state == "AK";
	gen stata_date = mdy(month,day,year);
	gen stata_sunset = clock(sunset,"hm");
	gen stata_sunrise = clock(sunrise,"hm");
	format stata_sunset %tc; 
	format stata_sunrise %tc; 
	
	** Keep relevant times;
	gen sunset_hour = hhC(stata_sunset);
	gen sunset_min = mmC(stata_sunset);
	gen sunrise_hour = hhC(stata_sunrise);
	gen sunrise_min = mmC(stata_sunrise);
	
	** Drop full sunrise/sunset variables . . . save space, etc;
	drop stata_sunset stata_sunrise;	

	** Change sunset by time zone – baseline is central;
	replace sunset_hour = sunset_hour + 1 if zone == "E";
	replace sunrise_hour = sunrise_hour + 1 if zone == "E";
	replace sunset_hour = sunset_hour - 1 if zone == "M";
	replace sunrise_hour = sunrise_hour - 1 if zone == "M";
	replace sunset_hour = sunset_hour - 2 if zone == "P";
	replace sunrise_hour = sunrise_hour - 2 if zone == "P";
	
	rename stata_date offdate;
	replace state = lower(state);
	keep state offdate sunset_hour sunset_min sunrise_hour sunrise_min year month day zone ori fips AGENTYPE latitude longitude;

	** Generate period of sunset THE DAY BEFORE DST;
	gen daybefore = .;
	foreach year in 2005 2006 2007 2008 {;
		replace daybefore = `dst`year'' - 1 if year == `year';
	};
		
	gen daybefore_fake = .;
	foreach year in 2005 2006 2007 2008 {;
		replace daybefore_fake = `dst`year'fake' - 1 if year == `year';
	};

	gen daybefore_end = .;
	foreach year in 2005 2006 2007 2008 {;
		replace daybefore_end = `laterdst`year'' - 1 if year == `year';
	};	
	
	** Adjust time for dst;
	gen dst = offdate > daybefore & offdate <= daybefore_end;
	gen fake_dst = offdate > daybefore_fake;

	gen clock_sunset_hour = sunset_hour;
	gen clock_sunset_min = sunset_min;
	replace clock_sunset_hour = sunset_hour + 1 if dst == 1;
	
	** Sunset - start of DST;
		gen dst_sunset_hour = sunset_hour if offdate == daybefore;
		egen tempdst = max(dst_sunset_hour), by(ori year);
		replace dst_sunset_hour = tempdst;
		drop tempdst;

		gen dst_sunset_min = sunset_min if offdate == daybefore;
		egen tempdst = max(dst_sunset_min), by(ori year);
		replace dst_sunset_min = tempdst;
		drop tempdst;

	** Sunset, end of DST;
		gen dstend_sunset_hour = sunset_hour if offdate == daybefore_end;
		egen tempdst = max(dstend_sunset_hour), by(ori year);
		replace dstend_sunset_hour = tempdst;
		drop tempdst;

		gen dstend_sunset_min = sunset_min if offdate == daybefore_end;
		egen tempdst = max(dstend_sunset_min), by(ori year);
		replace dstend_sunset_min = tempdst;
		drop tempdst;

	** Sunset, fake start of DST;
		gen fakedst_sunset_hour = sunset_hour if offdate == daybefore_fake;
		egen tempdst = max(fakedst_sunset_hour), by(ori year);
		replace fakedst_sunset_hour = tempdst;
		drop tempdst;
		
		gen fakedst_sunset_min = sunset_min if offdate == daybefore_fake;
		egen tempdst = max(fakedst_sunset_min), by(ori year);
		replace fakedst_sunset_min = tempdst;
		drop tempdst;	
	
		compress;
		
	save `fileloc'/data/sunset.dta, replace;

};


**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - HOURLY XXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

if `hourly' == 1 {;

	** The following code import the raw NIBRS data, obtained from ICPSR;
	** Use batch header 1 ("_1" below) and administrative data ("_4" below) segments

	** Hourly crime data;

	**2005;
	use `fileloc'/data/nibrs/nibrs2005_1;
	rename B1003 ori;
	rename B1009 pop_group;
	keep ori pop_group;
	sort ori;
	save `fileloc'/data/nibrs/nibrs2005_1_dst, replace;	
	clear;
	
	use `fileloc'/data/nibrs/nibrs2005_4;
	rename V1003 ori;
	rename V1004 incident;
	rename V1006 reported;
	rename V1007 hour;
	rename V1011 arrestees;
	rename V1013 cleared_excep;
	keep ori incident reported hour arrestees cleared_excep;
	replace hour = 99 if hour==.;
	gen arrest = arrestees>0 & arrestees!=.;
	gen solved = arrest==1 | (cleared_excep!="N" & cleared_excep!=" ");
	sort ori incident;	
	save `fileloc'/data/nibrs/nibrs2005_4_dst, replace;
	clear;

	**2006;	
	use `fileloc'/data/nibrs/nibrs2006_1;
	rename B1003 ori;
	rename B1009 pop_group;
	keep ori pop_group;
	sort ori;
	save `fileloc'/data/nibrs/nibrs2006_1_dst, replace;
	clear;
	
	use `fileloc'/data/nibrs/nibrs2006_4;
	rename V1003 ori;
	rename V1004 incident;
	rename V1006 reported;
	rename V1007 hour;
	rename V1011 arrestees;
	rename V1013 cleared_excep;
	keep ori incident reported hour arrestees cleared_excep;
	replace hour = 99 if hour==.;
	gen arrest = arrestees>0 & arrestees!=.;
	gen solved = arrest==1 | (cleared_excep!="N" & cleared_excep!=" ");
	sort ori incident;
	save `fileloc'/data/nibrs/nibrs2006_4_dst, replace;
	clear;

	**2007;
	use `fileloc'/data/nibrs/nibrs2007_1;
	rename B1003 ori;
	rename B1009 pop_group;
	keep ori pop_group;
	sort ori;
	save `fileloc'/data/nibrs/nibrs2007_1_dst, replace;
	clear;
	
	use `fileloc'/data/nibrs/nibrs2007_4;
	rename V1003 ori;
	rename V1004 incident;
	rename V1006 reported;
	rename V1007 hour;
	rename V1011 arrestees;
	rename V1013 cleared_excep;
	keep ori incident reported hour arrestees cleared_excep;
	replace hour = 99 if hour==.;
	gen arrest = arrestees>0 & arrestees!=.;
	gen solved = arrest==1 | (cleared_excep!="N" & cleared_excep!=" ");
	sort ori incident;
	save `fileloc'/data/nibrs/nibrs2007_4_dst, replace;
	clear;
	
	use `fileloc'/data/nibrs/nibrs2008_1;
	rename B1003 ori;
	rename B1009 pop_group;
	keep ori pop_group;
	sort ori;
	save `fileloc'/data/nibrs/nibrs2008_1_dst, replace;
	clear;

	**2008;	
	use `fileloc'/data/nibrs/nibrs2008_4;
	rename V1003 ori;
	rename V1004 incident;
	rename V1006 reported;
	rename V1007 hour;
	rename V1011 arrestees;
	rename V1013 cleared_excep;
	keep ori incident reported hour arrestees cleared_excep;
	replace hour = 99 if hour==.;
	gen arrest = arrestees>0 & arrestees!=.;
	gen solved = arrest==1 | (cleared_excep!="N" & cleared_excep!=" ");

	** Drop missing location identifier observations;
	drop if ori == "";

	sort ori incident;
	save `fileloc'/data/nibrs/nibrs2008_4_dst, replace;
	clear;

};




**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXX DATA BUILDING - ALL OTHER XXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

** Use NIBRS batch header 2 ("_2" below) and offense-level data ("_5" below) segments;

if `basedata' == 1 {;
	
	foreach year in 2005 2006 2007 2008 {;
			
		use `fileloc'/data/nibrs/nibrs`year'_2, clear;
		rename B2003 ori;
		rename B2005 pop1;
		rename B2009 pop2;
		rename B2013 pop3;
		rename B2017 pop4;
		collapse (mean) pop1 pop2 pop3 pop4, by(ori);
		sort ori;
		save `fileloc'/data/nibrs/nibrs`year'_2_dst, replace;
		clear;
		
		use `fileloc'/data/nibrs/nibrs`year'_5;
		
		label var V2001  "SEGMENT LEVEL";
		label var V2002  "NUMERIC STATE CODE";
		label var V2003  "ORIGINATING AGENCY IDENTIFIER";
		label var V2004  "INCIDENT NUMBER";
		label var V2005  "INCIDENT DATE";
		label var V2006  "UCR OFFENSE CODE";
		label var V2007  "OFFENSE ATTEMPTED / COMPLETED";
		label var V2008  "OFFENDER(S) SUSPECTED OF USING 1";
		label var V2009  "OFFENDER(S) SUSPECTED OF USING 2";
		label var V2010  "OFFENDER(S) SUSPECTED OF USING 3";
		label var V2011  "LOCATION TYPE";
		label var V2012  "NUMBER OF PREMISES ENTERED";
		label var V2013  "METHOD OF ENTRY";
		label var V2014  "TYPE CRIMINAL ACTIVITY/GANG INFO 1";
		label var V2015  "TYPE CRIMINAL ACTIVITY/GANG INFO 2";
		label var V2016  "TYPE CRIMINAL ACTIVITY/GANG INFO 3";
		label var V2017  "WEAPON / FORCE 1";
		label var V2018  "WEAPON / FORCE 2";
		label var V2019  "WEAPON / FORCE 3";
		label var V2020  "BIAS MOTIVATION";
		label var V2021  "N RECORDS PER ORI-INCIDENT NUMBER";
		
		gen sample_aggassault = V2006=="13A" & V2007=="C";
		gen sample_simpleassault = V2006=="13B" & V2007=="C";
		gen sample_intimidation = V2006=="13C" & V2007=="C";
		gen sample_bribery = V2006=="510" & V2007=="C";
		gen sample_burglary = V2006=="220" & V2007=="C";
		gen sample_forgery = V2006=="250" & V2007=="C";
		gen sample_damageprop = V2006=="290" & V2007=="C";
		gen sample_drug = V2006=="35A" & V2007=="C";
		gen sample_drugequip = V2006=="35B" & V2007=="C";
		gen sample_embezzlement = V2006=="270" & V2007=="C";
		gen sample_extortion = V2006=="210" & V2007=="C";
		gen sample_swindle = V2006=="26A" & V2007=="C";
		gen sample_creditfraud = V2006=="26B" & V2007=="C";
		gen sample_impersonation = V2006=="26C" & V2007=="C";
		gen sample_welfarefraud = V2006=="26D" & V2007=="C";
		gen sample_wirefraud = V2006=="26E" & V2007=="C";
		gen sample_gambling = V2006=="39A" & V2007=="C";
		gen sample_gamblingpromot = V2006=="39B" & V2007=="C";
		gen sample_gamblingequip = V2006=="39C" & V2007=="C";
		gen sample_murder = V2006=="09A" & V2007=="C";
		gen sample_negmanslaughter = V2006 == "09B" & V2007=="C";
		gen sample_justifiablehomicide = V2006=="09C" & V2007=="C";
		gen sample_kidnapping = V2006=="100" & V2007=="C";
		gen sample_pickpocket = V2006=="23A" & V2007=="C";
		gen sample_pursesnatch = V2006=="23B" & V2007=="C";
		gen sample_shoplifting = V2006 == "23C" & V2007=="C";
		gen sample_theftbldg = V2006 == "23D" & V2007=="C";
		gen sample_theftcoinopmach = V2006=="23E" & V2007=="C";
		gen sample_theftmotorveh = V2006 == "23F" & V2007=="C";
		gen sample_theftparts = V2006 == "23G" & V2007=="C";
		gen sample_theftoth = V2006 == "23H" & V2007=="C";
		gen sample_vtheft = V2006=="240" & V2007=="C";
		gen sample_obscenemat = V2006=="370" & V2007=="C";
		gen sample_prostitution = V2006=="40A" & V2007=="C";
		gen sample_prostitutionpromot = V2006=="40B" & V2007=="C";
		gen sample_robbery = V2006=="120" & V2007=="C";
		gen sample_rape = V2006=="11A" & V2007=="C";
		gen sample_sodomy = V2006=="11B" & V2007=="C";
		gen sample_sexassaultobj = V2006=="11C" & V2007=="C";
		gen sample_forcfondling = V2006=="11D" & V2007=="C";
		gen sample_incest = V2006=="36A" & V2007=="C";
		gen sample_statrape = V2006=="36B" & V2007=="C";
		gen sample_stolprop = V2006=="280" & V2007=="C";
		gen sample_weapon = V2006=="520" & V2007=="C";
		gen sample_arson_att = V2006=="200" & V2007=="A";
		gen sample_aggassault_att = V2006=="13A" & V2007=="A";
		gen sample_simpleassault_att = V2006=="13B" & V2007=="A";
		gen sample_intimidation_att = V2006=="13C" & V2007=="A";
		gen sample_bribery_att = V2006=="510" & V2007=="A";
		gen sample_burglary_att = V2006=="220" & V2007=="A";
		gen sample_forgery_att = V2006=="250" & V2007=="A";
		gen sample_damageprop_att = V2006=="290" & V2007=="A";
		gen sample_drug_att = V2006=="35A" & V2007=="A";
		gen sample_drugequip_att = V2006=="35B" & V2007=="A";
		gen sample_embezzlement_att = V2006=="270" & V2007=="A";
		gen sample_extortion_att = V2006=="210" & V2007=="A";
		gen sample_swindle_att = V2006=="26A" & V2007=="A";
		gen sample_creditfraud_att = V2006=="26B" & V2007=="A";
		gen sample_impersonation_att = V2006=="26C" & V2007=="A";
		gen sample_welfarefraud_att = V2006=="26D" & V2007=="A";
		gen sample_wirefraud_att = V2006=="26E" & V2007=="A";
		gen sample_gambling_att = V2006=="39A" & V2007=="A";
		gen sample_gamblingpromot_att = V2006=="39B" & V2007=="A";
		gen sample_gamblingequip_att = V2006=="39C" & V2007=="A";
		gen sample_murder_att = V2006=="09A" & V2007=="A";
		gen sample_negmanslaughter_att = V2006 == "09B" & V2007=="A";
		gen sample_justifiablehomicide_att = V2006=="09C" & V2007=="A";
		gen sample_kidnapping_att = V2006=="100" & V2007=="A";
		gen sample_pickpocket_att = V2006=="23A" & V2007=="A";
		gen sample_pursesnatch_att = V2006=="23B" & V2007=="A";
		gen sample_shoplifting_att = V2006 == "23C" & V2007=="A";
		gen sample_theftbldg_att = V2006 == "23D" & V2007=="A";
		gen sample_theftcoinopmach_att = V2006=="23E" & V2007=="A";
		gen sample_theftmotorveh_att = V2006 == "23F" & V2007=="A";
		gen sample_theftparts_att = V2006 == "23G" & V2007=="A";
		gen sample_theftoth_att = V2006 == "23H" & V2007=="A";
		gen sample_vtheft_att = V2006=="240" & V2007=="A";
		gen sample_obscenemat_att = V2006=="370" & V2007=="A";
		gen sample_prostitution_att = V2006=="40A" & V2007=="A";
		gen sample_prostitutionpromot_att = V2006=="40B" & V2007=="A";
		gen sample_robbery_att = V2006=="120" & V2007=="A";
		gen sample_rape_att = V2006=="11A" & V2007=="A";
		gen sample_sodomy_att = V2006=="11B" & V2007=="A";
		gen sample_sexassaultobj_att = V2006=="11C" & V2007=="A";
		gen sample_forcfondling_att = V2006=="11D" & V2007=="A";
		gen sample_incest_att = V2006=="36A" & V2007=="A";
		gen sample_statrape_att = V2006=="36B" & V2007=="A";
		gen sample_stolprop_att = V2006=="280" & V2007=="A";
		gen sample_weapon_att = V2006=="520" & V2007=="A";
		
		tostring V2005, gen(offdate_str);
		gen offdate = date(offdate_str, "YMD");
		rename V2002 state;
		rename V2003 ori;
		rename V2004 incident ;
		rename V2011 location;
		rename V2017 weapon;
		rename V2021 numrecords;
		
		forvalues i = 1/25{;
		gen location`i' = location==`i';
		};
		
		** Generate data set of just offense and date;
		preserve;
		keep ori incident offdate;
		save `fileloc'/data/just_dates_`year'.dta, replace;
		restore;
		
		collapse  (max) state (sum) sample*, by(ori incident offdate) fast;
			
		** Add in hourly data;
		sort ori incident;
		merge 1:1 ori incident using `fileloc'/data/nibrs/nibrs`year'_4_dst;
		keep if _merge == 3;
		drop _merge;
			
		collapse (max) state (sum) sample*, by(ori offdate hour) fast;
		
		joinby ori using `fileloc'/data/nibrs/nibrs`year'_1_dst;
		joinby ori using `fileloc'/data/nibrs/nibrs`year'_2_dst;
		
		foreach i in  aggassault murder  robbery  rape {;
			gen rate_`i' = 1000000*sample_`i'/(pop1+pop2+pop3+pop4);
			gen rate_`i'_att = 1000000*sample_`i'_att/(pop1+pop2+pop3+pop4);
		};
		
		gen year = year(offdate);
		tab year;

		** Drop crimes that indicate occurrence in prior year;
		keep if year == `year';
			
		gen population = pop1 + pop2 + pop3 + pop4;
		
		** Remove jurisdictions with 0 or missing population data;
		drop if population == 0 | population == .;
		
		qui compress;

		save `fileloc'/data/nibrs/dst`year', replace;
			
	};

};


/* 

COMMENTS

Coding Population Group variable:

0 = Possessions
1 = All cities >= 250,000
1A = Citiies >= 1,000,000
1B = Cities 500,000-999,999
1C = Cities 250,000-499,999
2 = Cities 100,000-249,999
3 = Cities 50,000-99,999
4 = Cities 25,000-49,999
5 = Cities 10,000-24,999
6 = Cities 2,500-9,999
7 = Cities < 2,500
8 = Non-MSA Counties
8A = Non-MSA Counties >= 100,000
8B = Non-MSA Counties 25,000-99,999
8C = Non-MSA Counties 10,000-24,999
8D = Non-MSA Counties < 10,000
8E = Non-MSA State Police
9 = MSA Counties
9A = MSA Counties >= 100,000
9B = MSA Counties 25,000-99,999
9C = MSA Counties 10,000-24,999
9D = MSA Counties < 10,000
9E = MSA State Police

 Coding Incident Hour:

Military time: 
0 = 12-12:59am
1 = 1-1:59am
. . . 
17 = 5-5:59pm
18 = 6-6:59pm
19 = 7-7:59pm
20 = 8-8:59pm
. . . 
23 = 11-11:59pm

blank = unknown time -- set this to = 99 instead


Other notes:

arrestees = number of arrestees within one year
created variable "arrest" = at least one arrest
clear_excep = "exceptional clearance" -- offender died, victim refused to cooperate, other non-arrest circumstances
created variable "solved" = arrest made or exceptionally cleared
this indicates whether the crime was "solved" in one way or another

collapsed dataset currently tallies # of crimes per hour and # of arrests & solved crimes per hour

Upload code & data.

Drop IN (changed DST boundaries) and AZ (no DST).
Whether arrest was made.
Hours of daylight -- by state.  Time of sunset. 

DST: 

1st Sun in April	last Sun in Oct
2001: April 1 = 15066	Oct 28 = 15276
2002: April 7 = 15437	Oct 27 = 15640
2003: April 6 = 15801	Oct 26 = 16004
2004: April 4 = 16165	Oct 31 = 16375
2005: April 3 = 16529	Oct 30 = 16739
2006: April 2 = 16893	Oct 29 = 17103

2nd Sun in March	1st Sun in Nov
2007: Mar 11 =  17236	Nov 4 = 17474
2008: Mar 9 = 17600	Nov 2 = 17838



2nd Sunday in March:		1st Sunday in April
2001: Mar 11 = 15045		Apr 1 = 15066
2002: Mar 10 = 15409		Apr 7 = 15437
2003: Mar 9 = 15773		Apr 6 = 15801
2004: Mar 14 = 16144		Apr 4 = 16165
2005: Mar 13 = 16508		Apr 3 = 16529
2006: Mar 12 = 16872		Apr 2 = 16893
2007: Mar 11 =  17236		Apr 1 = 17257
2008: Mar 9 = 17600		Apr 6 = 17628

last Sunday in Oct:		1st Sunday in Nov
2001: Oct 28 = 15276		Nov 4 = 15283
2002: Oct 27 = 15640		Nov 3 = 15647	
2003: Oct 26 = 16004		Nov 2 = 16011	
2004: Oct 31 = 16375		Nov 7 = 16382
2005: Oct 30 = 16739		Nov 6 = 16746	
2006: Oct 29 = 17103		Nov 5 = 17110	
2007: Oct 28 = 17467		Nov 4 = 17474
2008: Oct 26 = 17831		Nov 2 = 17838

*/;




**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ANALYSIS  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;
**XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX;

if `rebuild' == 1 {;

	use `fileloc'/data/nibrs/dst2005, clear;
	append using `fileloc'/data/nibrs/dst2006;
	append using `fileloc'/data/nibrs/dst2007;
	append using `fileloc'/data/nibrs/dst2008;

	gen state_ar = state==3;
	gen state_az = state==2;
	gen state_ca = state==4;
	gen state_co = state==5;
	gen state_ct = state==6;
	gen state_de = state==7;
	gen state_dc = state==8;
	gen state_fl = state==9;
	gen state_ga = state==10;
	gen state_hi = state==51;
	gen state_ia = state==14;
	gen state_id = state==11;
	gen state_il = state==12;
	gen state_in = state==13;
	gen state_ks = state==15;
	gen state_ky = state==16;
	gen state_la = state==17;
	gen state_ma = state==20;
	gen state_md = state==19;
	gen state_me = state==18;
	gen state_mi = state==21;
	gen state_mn = state==22;
	gen state_mo = state==24;
	gen state_ms = state==23;
	gen state_mt = state==25;
	gen state_ne = state==26;
	gen state_nc = state==32;
	gen state_nd = state==33;
	gen state_nh = state==28;
	gen state_nj = state==29;
	gen state_nm = state==30;
	gen state_nv = state==27;
	gen state_ny = state==31;
	gen state_pa = state==37;
	gen state_oh = state==34;
	gen state_ok = state==35;
	gen state_or = state==36;
	gen state_ri = state==38;
	gen state_sc = state==39;
	gen state_sd = state==40;
	gen state_tn = state==41;
	gen state_tx = state==42;
	gen state_ut = state==43;
	gen state_va = state==45;
	gen state_vt = state==44;
	gen state_wa = state==46;
	gen state_wi = state==48;
	gen state_wv = state==47;
	gen state_wy = state==49;
	
	gen mergestate = "";
	foreach state in ar az ca co ct de dc fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt ne nc nd nh nj nm nv ny pa oh ok or ri sc sd tn tx ut va vt wa wi wv wy {;
		qui replace mergestate = "`state'" if state_`state' == 1;
	};

	** Drop irrelevant crimes not included in analysis, compress data for saving space;		
	drop sample_*;
	qui compress;

	save `fileloc'/data/allyears.dta, replace;

	use `fileloc'/data/allyears.dta, clear;
	
	** Trim some variables . . . ;
	foreach var in arson  bribery   damageprop  drug  drugequip  embezzlement  extortion   creditfraud  impersonation  welfarefraud  wirefraud  gambling  gamblingpromot  gamblingequip  negmanslaughter  justifiablehomicide   pickpocket  pursesnatch   theftbldg  theftcoinopmach theftparts vtheft  obscenemat prostitutionpromot  sodomy  sexassaultobj  forcfondling  incest  statrape  weapon {;
		cap drop rate_`var'*;
	};

	** drop Arizona – few reliable obs, don't observe daylight saving;
	drop if state_az == 1;
	** Drop Henrico County in VA due to highly inconsistent reporting data;
	drop if ori == "VA0430100";
	
	foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {;
		gen `crime'_combined = `crime'_att + `crime';
		gen any_`crime' = `crime' > 0 & `crime' ~= .;
		gen `crime'_count = `crime' * (population/1000000);
	};
	
	** Generate month variable;
	gen month = month(offdate);

	** Drop missing hour data;
	drop if hour == 99;
	drop if hour == .;
	** Lots of obs reported at midnight and noon, indicative of reporting bunching. Drop some observations where those are the modal reporting time;
	egen modehour = mode(hour), by(ori) minmode;
	sum modehour, d;
	preserve;
	sample 1, by(ori year) count;
	hist modehour, w(1)
		$graph_options;
	graph export `fileloc'/figures/mode_hour_histogram.eps, replace;
	restore;
		
	drop if modehour == .;
			
	** Make sure there is at least one observation per month per year to avoid regions dropping in and out of sample;
	preserve;
	bysort ori year month: keep if _n == 1;
	by ori: gen months_total = _N;
	tab months_total;
	keep if months_total == 48;
	keep ori;
	bysort ori: keep if _n ==1;
	tempfile allmonths;
	save `allmonths';
	restore;	
		
	joinby ori using `allmonths';

	** Build variable for total number of crimes in a year;
	foreach crime in 
		rate_rape 
		rate_aggassault 
		rate_murder 
		rate_robbery  {;
		egen total`crime' = sum(`crime'_count), by(ori year);
		egen mintotal`crime' = min(total`crime'), by(ori);
		drop total*;
	};

	** Keep only regions that have at least one crime per year for robbery, assault, rape;
	drop if mintotalrate_robbery == 0;
	drop if mintotalrate_aggassault == 0;
	drop if mintotalrate_rape == 0;
	
	tab pop_group;
	
	** Keep only certain variables to save data space;
	keep rate* ori hour offdate population mergestate year month modehour mintotal*;

	** Check for and remove any duplicate observations;
	duplicates tag ori offdate hour, g(dupes);
	tab dupes;
	drop dupes;
	
	compress;
	
	save `fileloc'/data/building.dta, replace;


	** General day file, days with no reported crime are not included. This section generates an observation per jurisdiction per year, so that no day/location cells are missing;
	
	** Determine main period ;
	use `fileloc'/data/building.dta, clear;
	keep offdate ori population mergestate modehour;
	gen year = year(offdate);
	drop offdate;
	** Keep one per year;
	sample 1, by(year ori) count;
							
	** One obs per day for each;
	expand (365);
	gen day1 = .;
	foreach year in 2005 2006 2007 2008 {;
		replace day1 = td(1jan`year') if year == `year';
	};
	format day1 %td;			
	tab day1;

	bysort ori year: gen offdate = day1 + _n - 1;
	format offdate %td;	

	gen year2 = year(offdate);
	drop if year2 ~= year;
			
	duplicates drop ori offdate, force;
	drop if year > 2008;
	
	** Make one for each hour;
	expand (24);
	bysort ori offdate: gen hour = (_n - 1);

	compress;
	
	keep ori offdate hour population mergestate modehour;
	sort ori offdate hour;  	
	save `fileloc'/data/alldays.dta, replace;
				
	use `fileloc'/data/building.dta, clear;
	
	** Drop duplicates variable names to prevent incorrect merge issues;
	drop population mergestate modehour;
	
	** Merge on all days;
	sort ori offdate hour;
	merge ori offdate hour using `fileloc'/data/alldays.dta;
		
	tab _merge;
	drop if _merge == 1;
	
	** Generate a 0 value for any crime that did not occur rather than have data for that crime be missing;
	foreach var in 
		rate_robbery 
		rate_rape 
		rate_aggassault 
		rate_murder 
		rate_robbery_combined
		rate_rape_combined
		rate_aggassault_combined 
		rate_murder_combined 
		rate_robbery_count
		rate_rape_count 
		rate_aggassault_count 
		rate_murder_count 		
	{;
		replace `var' = 0 if _merge == 2;
	};
	drop _merge;
	
	gen dow = dow(offdate);
	tab dow;
		
	** Add on sunset data, dst, and location data;
	sort ori offdate;
	tempfile states;
	save `states';
	use `fileloc'/data/sunset.dta, clear;
	sort ori offdate;
	merge ori offdate using `states';
	tab _merge;
	keep if _merge == 3;
	drop _merge;

	** Generate "running day" variable (and fake one, too), treating beginning of DST as day 0. Slope can vary on either side, so we create a variable for days since and days before;
	gen running_day = (offdate - daybefore) - 1;
	gen running_day_fake = (offdate - daybefore_fake) - 1;
	gen rdcontinuous = running_day;
	gen running_dayint = running_day*dst;
	replace running_day = 0 if dst == 1;
	
	** Generate "hours since sunset", real and fake for later robustness checks;
	gen hours_since_sunset = .;
	replace hours_since_sunset = hour - (dst_sunset_hour + dst_sunset_min/60);
	sum hours_since_sunset;	
	gen cleaned_hours = round(hours_since_sunset,1);
	gen hours_since_sunset_fake = .;
	replace hours_since_sunset_fake = hour - (fakedst_sunset_hour + fakedst_sunset_min / 60);
	gen cleaned_hours_fake = round(hours_since_sunset_fake,1);

	** Generate "hours since sunset", for end of dst;
	gen hours_since_sunset_end = .;
	replace hours_since_sunset_end = hour - (dstend_sunset_hour + dstend_sunset_min/60);
	sum hours_since_sunset_end;	
	gen cleaned_hours_end = round(hours_since_sunset_end,1);
	
	** Generate indicator for jurisdiction-by-year;
	egen ori_by_year = group(ori year);		
	qui compress;
	
	** Check for duplicate observations;
	duplicates tag ori offdate hour, g(dupes);
	tab dupes;
	drop dupes;

	if `add_weather' == 1 {;
		**Weather data provided by Wolfram Schlenker – contact Prof. Schlenker for any data requests;
		** Add weather data;
		joinby fips offdate using `weather_location';
	};
	
		gsort ori, g(ori_cluster);
		
	save `fileloc'/data/maindata.dta, replace;
	
};











**********************;
**********************;
**********************;
** Replicate Figure 1;
**********************;
**********************;
**********************;
** Balanced panel;
use ori zone latitude longitude modehour using `fileloc'/data/maindata.dta if modehour ~= 0, clear;
		
bysort ori: keep if _n == 1;
	
gsort zone, g(zone2);

gen zonesort = .;
replace zonesort = 1 if zone == "P";
replace zonesort = 2 if zone == "M";
replace zonesort = 3 if zone == "C";
replace zonesort = 4 if zone == "E";
drop zone;
rename zonesort zone;

label define zoneval 1 "Pacific" 2 "Mountain" 3 "Central" 4 "Eastern";
label values zone zoneval;
	
save `fileloc'/data/ori_location_balanced.dta, replace;

use `fileloc'/data/GIS/states-d.dta, clear;	
	spmap using "`fileloc'/data/GIS/states-c", 
		freestyle aspect(0.5)
		id(_ID)		
		point(data("`fileloc'/data/ori_location_balanced.dta") xcoord(longitude) ycoord(latitude) size(vsmall) by(zone) fcolor(blue red orange green) shape(o d t s) legenda(on) legtitle("Time Zone") leglabel(zone))
		$graph_options
		yscale(off)
		xscale(off)
		ylabel(, nogrid);
graph export `fileloc'/figures/reporting_balanced.eps, replace;
shell rm `fileloc'/data/ori_location_200*.dta;
shell rm `fileloc'/data/ori_location_balanced.dta;

**********************;
**********************;
**********************;
** Replicate Figure 2;
**********************;
**********************;
**********************;
use modehour ori_cluster year daybefore* dst* offdate using `fileloc'/data/maindata.dta if modehour ~= 0, clear;

** Only want day before DST begins in spring;
keep if offdate == daybefore;
sample 1, by(ori_cluster year) count;
tab year;
gen hourandminute = round((dst_sunset_hour + dst_sunset_min/60),0.125) ;
	
foreach year in 2005 2006 2007 2008 {;
	twoway hist hourandminute if year == `year', 
		percent
		start(17.5) width(0.25)
		xlabel(17.5(.5)19.5)
		xtitle("Day Before DST Sunset Hour")
		ytitle("Percent")
		title(`year')
		$graph_options
		saving(`fileloc'/figures/sunset_distribution_`year'.gph, replace);	
};
graph combine `fileloc'/figures/sunset_distribution_2005.gph
	`fileloc'/figures/sunset_distribution_2006.gph
	`fileloc'/figures/sunset_distribution_2007.gph
	`fileloc'/figures/sunset_distribution_2008.gph,
		ycommon iscale(0.5)
		$graph_options;
graph export `fileloc'/figures/sunset_distribution.eps, replace;
shell rm `fileloc'/figures/sunset_distribution_200*.gph;




**********************;
**********************;
**********************;
** Replicate Figure 3;
**********************;
**********************;
**********************;
foreach crime in rate_murder rate_robbery rate_aggassault rate_rape  {;

	local cutter = 8*7;
	
	use `fileloc'/data/maindata.dta if modehour ~= 0, clear;

	** Omit weekends due to more extreme values – weekends included in all table regressions;
	drop if dow == 0 | dow == 6;

	** Combine attempted and successful;
	replace `crime' = `crime'_combined;

	collapse (sum) `crime' (mean) dst dow population year ori_by_year running_day running_dayint rdcontinuous, by(ori_cluster offdate) fast;

	gen week = week(offdate);
			
	tempfile local_linear_run;
	save `local_linear_run';
	
	collapse dow `crime' [aw = population], by(rdcontinuous) fast;
	rename rdcontinuous running_day;
	tempfile means;
	save `means';
	
	postutil clear;
	tempname locallinear;
			
	postfile `locallinear' running_day predicted_rob upperCI lowerCI dow using `fileloc'/data/local_linear_graphs_day.dta, replace;
		
	local llband = (21);
	
	forvalues day = -`cutter'/`cutter' {;
			use `local_linear_run', clear;

			quietly {;

				keep if rdcontinuous >= `day' - `llband' & rdcontinuous <= `day' + `llband' ;
			
				sum dow if rdcontinuous == `day';
				local dow = r(mean);

				reg `crime' dst running_day running_dayint [aw = population]; 
			
				clear;
				set obs 1;
				gen dst = (`day' >= 0);
				gen running_day = `day'*(1 - dst);
				gen running_dayint = `day' * dst;
			
				** predict estimate;
				predict localestimate;
				** predict standard error of estimate;
				predict reg_st_dev, stdp;
				** Make CI around estimate;
				gen upperCI = localestimate + 1.96 * reg_st_dev;
				gen lowerCI = localestimate - 1.96 * reg_st_dev;
			
			};
			
			post `locallinear' (`day') (localestimate) (upperCI) (lowerCI) (`dow');
		
	};
				
	postclose `locallinear';
		
	use `fileloc'/data/local_linear_graphs_day.dta, clear;
	append using `means';
	
	drop if running_day < -`cutter' | running_day > `cutter';

	twoway line predicted_rob running_day if running_day < 0, lcolor(black) 
		|| line predicted_rob running_day if running_day >= 0, lcolor(black)	
		xline(0, lpattern(longdash) lcolor(gray))				
		|| scatter `crime' running_day, mcolor(gs12) msize(small) msymbol(O) mfcolor(none)		
			graphregion(fcolor(white) lcolor(white))
			legend(off)
			ytitle("Rate per 1,000,000")
			xtitle("Day")
			xlabel(-`cutter'(7)`cutter')
			saving(`fileloc'/figures/local_linear_allyears_`crime'_daylevel, replace);

	graph export `fileloc'/figures/local_linear_allyears_`crime'_daylevel.eps, replace;
	
};


**********************;
**********************;
**********************;
** Replicate Figure 4;
**********************;
**********************;
**********************;
** Last three weeks of March;
** Weeks that shift between 2005/2006 and 2007/2008;
use `fileloc'/data/maindata.dta if modehour ~= 0, clear;	
keep if month == 3 & day > 11;
gen dayofyear = doy(offdate);
	
cap drop _I*;

** Use hours since suset as identifier;
replace hour = cleaned_hours;
xi i.dst*i.hour i.dow, noomit;
sum cleaned_hours;
local min = r(min);

** Select omitted categories;
drop _Idst_0;
drop _Ihour_1;
drop _Idst_1;
drop _IdstXhou_0*;

areg rate_robbery_combined _I* `weather' [aw = population], cluster(ori_cluster) absorb(ori_cluster);
parmest, fast; 
	gen keepvar = substr(parm,1,6);
	keep if keepvar == "_IdstX";
	gen month = 3;
	save `fileloc'/data/parm_march, replace;

gen hour = _n + `min' - 1;
destring hour, replace;

twoway line estimate hour, lpattern(solid) lcolor(blue) mfcolor(blue)			
	|| line min95 hour, lpattern(dot) lcolor(red) 
	|| line max95 hour, lpattern(dot) lcolor(red)	
	xtitle("Hours Since Sunset")
	ytitle("Differential Between DST and non-DST Years")
	$graph_options
	legend(off);
	
graph export `fileloc'/figures/rate_robbery_dind.eps, replace;


**********************;
**********************;
**********************;
** Replicate Appendix Figure 1;
**********************;
**********************;
**********************;
** ALL DATES;
use `fileloc'/data/maindata.dta if modehour ~= 0 & (cleaned_hours == 0 | cleaned_hours == 1), clear;	

replace rate_robbery = (rate_robbery_combined);

gen dayofyear = doy(offdate);

** Need a running day variable for each fake DST situation;
gen running_day_new = .;
foreach year in 2005 2006 2007 2008 {;
	sum dayofyear if offdate == `dst`year'';
	local meanset = r(mean);
	replace running_day_new = dayofyear - `meanset' if year == `year';
};
	
collapse (sum) rate_robbery (mean) population year dow ori_cluster `weather' fips, by(ori_by_year running_day_new) fast;

xi i.dow, noomit;

postutil clear;
tempname tonsoffakes;
				
postfile `tonsoffakes' dayofyear effect std_error p_val using `fileloc'/data/a_bunch_of_fakes.dta, replace;
			
tempfile alldays;
save `alldays';

	quietly {;

		forvalues day = -60(1)250 {;

			use `alldays', clear;
			keep if running_day_new >= `day' - 21 & running_day_new <= `day' + 20;
			gen dst = 0;
			replace dst = 1 if running_day_new >= `day';
			gen running_day = running_day_new - `day';
			gen running_day_int = running_day*dst;
			replace running_day = 0 if dst == 1;

			areg rate_robbery _I* `weather' dst running_day running_day_int [aw = population], cluster(ori_cluster) absorb(ori_by_year);
			
			noisily di `day';
			local p = (2 * ttail(e(df_r), abs(_b[dst]/_se[dst])));
			
			post `tonsoffakes' (`day') (_b[dst]) (_se[dst]) (`p');

		};
	};
	
postclose `tonsoffakes';

use `fileloc'/data/a_bunch_of_fakes.dta, clear;

gen t = abs(effect/std_error);

save `fileloc'/data/a_bunch_of_fakes_runningday.dta, replace;

** Panel A;
use `fileloc'/data/a_bunch_of_fakes_runningday.dta, clear;

sum effect if dayofyear == 0;
local real = r(mean);

sum effect;
local begin = round(r(min)-.01,0.01);
twoway hist effect,
	frequency
	width(0.01) start(`begin')
	xline(`real', lpattern(dash))
	xtitle("Estimated Effect of DST Assignment")
	ytitle("Occurrence Count")
	xtick(-0.16(.02)0.16)
	xlabel(-0.16(.02)0.16)
	$graph_options;
	
graph export `fileloc'/figures/all_days_histogram.eps, replace;

** Panel B;
twoway scatter effect day if p_val < 0.05, msymbol(d) mcolor(gs06)
	|| scatter effect day if p_val >= 0.05, msymbol(X) mcolor(gs10)
	legend(label(1 "Statistically Significant (< 5%)") label(2 "Not Statistically Significant"))
	$graph_options
	xtitle("Days Since True DST")
	ytitle("Estimated Effect of DST Assignment");

graph export `fileloc'/figures/all_days_compared_runningday.eps, replace;



**********************;
**********************;
**********************;
** Replicate Table 1;
**********************;
**********************;
**********************;
** Generate mean values for Table 1;
** Means across time;
use `fileloc'/data/maindata.dta if rdcontinuous >= -21 & rdcontinuous <= 20 & modehour ~= 0, clear;

preserve;

local meancrimes = "rate_robbery rate_rape rate_aggassault rate_murder";
xtset ori_by_year;
postutil clear;
tempname xtsums;

postfile `xtsums' str16 crime str6 hour mean sd using `fileloc'/regs/means.dta, replace;
	
tempfile means;
save `means';

collapse (sum) rate_*_combined (mean) population, by(offdate ori_by_year);
foreach var in `meancrimes' {;

	sum `var' [aw = population];

	local mean = r(mean);
	local sd = r(sd);
	post `xtsums' ("`var'") ("all") (`mean') (`sd');
		
};

use `means', clear;
collapse (sum) rate_*_combined (mean) population, by(offdate ori_by_year dst);
foreach var in `meancrimes' {;

	sum `var' if dst == 0 [aw = population];
	local mean = r(mean);
	local sd = r(sd);
	post `xtsums' ("`var'") ("pre") (`mean') (`sd');

	sum `var' if dst == 1 [aw = population];
	local mean = r(mean);
	local sd = r(sd);
	post `xtsums' ("`var'") ("post") (`mean') (`sd');
	
};

use `means', clear;
keep if cleaned_hours == 0 | cleaned_hours == 1;
collapse (sum) rate_*_combined (mean) population, by(offdate ori_by_year dst);
foreach var in `meancrimes' {;

	sum `var' if dst == 0  [aw = population];
	local mean = r(mean);
	local sd = r(sd);
	post `xtsums' ("`var'") ("0,1 pre") (`mean') (`sd');

	sum `var' if dst == 1 [aw = population];
	local mean = r(mean);
	local sd = r(sd);
	post `xtsums' ("`var'") ("0,1 post") (`mean') (`sd');
	
};		
	
postclose `xtsums';
use `fileloc'/regs/means.dta, clear;
export excel `fileloc'/regs/means.xls, replace;
shell rm `fileloc'/regs/means.dta;

** Number of reporting regions and population;
restore;
sample 1, by(ori year) count;
count if ori == "";
gsort ori, g(ori_sort);	
egen totalpopulation = total(population), by(year);
replace totalpopulation = totalpopulation / 1000000;
format totalpopulation %16.9g;

foreach year in 2005 2006 2007 2008 {;
	estpost summarize totalpopulation ori_sort if year == `year'; 
	esttab using `fileloc'/regs/number_of_obs_`year'.xls,
		tab
		cells(mean max)
		replace;
};
	

**********************;
**********************;
**********************;
** Replicate Column 1 of Table 2;
**********************;
** Replicate Weekend Interactions (Table A-6);
**********************;
**********************;
**********************;
local crimesused "rate_robbery rate_rape rate_aggassault rate_murder";

** Regressions as RD;
use `fileloc'/data/maindata.dta if rdcontinuous >= -21 & rdcontinuous <= 20 &  modehour ~= 0, clear;	

gen weekend = (dow == 0 | dow == 6);
gen weekofyear = week(offdate);

** Use both attempted and successful crimes;
foreach crime in `crimesused'  {;
	replace `crime' = (`crime'_combined);
};

collapse (sum) `crimesused' (mean) population year dst dow month running_day running_dayint ori_cluster `weather' fips weekend rdcontinuous weekofyear, by(ori_by_year offdate) fast;

tempfile rdregs;
save `rdregs';

eststo clear;		
foreach crime in `crimesused' {;
	
	use `rdregs', clear;
	
	gen dstXweekend = dst*weekend;
	gen lnpop = ln(population);

	xi i.dow i.year, noomit;
	
	eststo clear;		
	areg `crime' _Idow* `weather' dst running_day running_dayint [aw = population], cluster(ori_cluster) absorb(ori_by_year);
	_eststo;
	
	** Generate pre-dst mean;
	sum `crime' if rdcontinuous < 0 [aw = population];	
	estadd scalar priorweekmean = r(mean);
	estadd scalar shareofmean = _b[dst] / r(mean);

	** Replicate Weekend Interactions (Table A-6);
	** Add weekend difference;
	areg `crime' _Idow* `weather' weekend dstXweekend dst running_day running_dayint [aw = population] if rdcontinuous >= -21 & rdcontinuous <= 20, cluster(ori_cluster) absorb(ori_by_year);
	_eststo;
						
esttab, 
	keep(dst dstXweekend) $esttab_opts;		

estout using `fileloc'/regs/daily_`crime'.xls, 
	keep(dst dstXweekend)
	cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
	replace
	starlevels(* 0.10 ** 0.05 *** 0.01)
	mlabels("Basic" "Add Weather" "Add Pop" "Add Year FE" "Add DoW FE")
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"));
	
esttab using `fileloc'/regs/daily_`crime'.tex, 
	keep(dst dstXweekend)
	replace
	$esttab_opts
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"));

};



**********************;
**********************;
**********************;
** Replicate Column 2 of Table 2;
**********************;
**********************;
**********************;
** Regressions as RD;
use `fileloc'/data/maindata.dta if rdcontinuous >= -21 & rdcontinuous <= 20 & modehour ~= 0, clear;	

collapse (sum) rate* (mean) `weather' dow running_day running_dayint dst population ori_cluster year rdcontinuous, by(ori_by_year offdate) fast;

foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {;
	replace `crime' = 1 if `crime'_combined > 0;
};

eststo clear;

xi i.dow;

xtset ori_by_year;
		
eststo clear;
	
foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {;

	xtreg `crime' _I* `weather' running_day running_dayint dst [aw = population], fe cluster(ori_cluster);
		
	eststo;

	sum `crime' if rdcontinuous < 0;
	di _b[dst] / r(mean);
	estadd scalar shareofmean = _b[dst] / r(mean);
	
};

	esttab, keep(dst);
	
	esttab using `fileloc'/regs/anycrime_day.tex, 
		keep(dst)
		replace
		stats(shareofmean, fmt(%9.2f) label("Share of Mean"))
		$esttab_opts;

	estout using `fileloc'/regs/anycrime_day.xls, 
		keep(dst)
		cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
		replace
		stats(shareofmean N, fmt(%9.3f %9.0fc))
		starlevels(* 0.10 ** 0.05 *** 0.01);

**********************;
**********************;
**********************;
** Replicate Columns 3 & 4 of Table 2;
**********************;
**********************;
**********************;
local crimesused "rate_robbery rate_rape rate_aggassault rate_murder";

** Regressions as RD;
use `fileloc'/data/maindata.dta if rdcontinuous >= -21 & rdcontinuous <= 20 & modehour ~= 0, clear;	

** Use both attempted and successful crimes;
foreach crime in `crimesused' {;
	replace `crime' = `crime'_combined;
};

** Keep only hours of sunset;
keep if cleaned_hours == 0 | cleaned_hours == 1;

collapse (sum) `crimesused' (mean) dow `weather' running_day running_dayint dst population ori_cluster rdcontinuous, by(ori_by_year offdate) fast;

xi i.dow;

xtset ori_by_year;

tempfile rdregs;
save `rdregs';

eststo clear;

foreach crime in `crimesused'  {;
		
	xtreg `crime' _I* `weather' running_day running_dayint dst [aw = population], cluster(ori_cluster) fe;
		
	_eststo;
		
	** Generate pre-dst mean;
	sum `crime' if rdcontinuous < 0 [aw = population];	
	estadd scalar priorweekmean = r(mean);
	estadd scalar shareofmean = _b[dst] / r(mean);
		
};

	esttab, 
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"))
	keep(dst) $esttab_opts;

	estout using `fileloc'/regs/rd_by_hour.xls, 
		keep(dst)
		cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
		replace
		stats(N shareofmean, fmt(%9.0fc %9.3f) label("Total Observations" "Share of Mean"))
		starlevels(* 0.10 ** 0.05 *** 0.01);
		
	esttab using `fileloc'/regs/rd_by_hour.tex, 
		keep(dst)
		replace
		stats(N shareofmean, fmt(%9.0fc %9.3f) label("Total Observations" "Share of Mean"))
		$esttab_opts;

eststo clear;

** Now linear probability model;
foreach crime in `crimesused' {;
	replace `crime' = 1 if  `crime' > 0;
	tab `crime';
};	


foreach crime in `crimesused'  {;
		
	xtreg `crime' _I* `weather' running_day running_dayint dst [aw = population], cluster(ori_cluster) fe;
		
	_eststo;
		
	sum `crime' if rdcontinuous < 0 [aw = population];	
	estadd scalar priorweekmean = r(mean);
	estadd scalar shareofmean = _b[dst] / r(mean);
		
	};

	esttab, 
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"))
	keep(dst) $esttab_opts;

	estout using `fileloc'/regs/anycrime_by_hour.xls, 
		keep(dst)
		cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
		replace
		stats(N shareofmean, fmt(%9.0fc %9.3f) label("Total Observations" "Share of Mean"))
		starlevels(* 0.10 ** 0.05 *** 0.01);
		
	esttab using `fileloc'/regs/anycrime_by_hour.tex, 
		keep(dst)
		replace
		stats(N shareofmean, fmt(%9.0fc %9.3f) label("Total Observations" "Share of Mean"))
		$esttab_opts;


**********************;
**********************;
**********************;
** Replicate Columns 5 & 6 of Table 2;
**********************;
**********************;
**********************;

use `fileloc'/data/maindata.dta if modehour ~= 0, clear;

** Keep only weeks that switch based on 2005/2006 or 2007/2008 period;
keep if month == 3 | month == 4;
drop if month == 3 & day < 9;
drop if month == 4 & day > 3;

gen sunset = (cleaned_hours == 0 | cleaned_hours == 1);

** All hours;
collapse (sum) rate_* (mean) `weather' population dst dow year ori_cluster day, by(offdate ori_by_year sunset) fast;

gen dstXsunset = dst * sunset;
		
** rate (column 5);
foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {;
				
	reg `crime'_combined dst dstXsunset sunset [aw = population], cluster(ori_cluster);
	eststo;

	sum `crime' if year == 2005 | year == 2006 & sunset == 1 [aw = population];	
	estadd scalar priorweekmean = r(mean);
	estadd scalar shareofmean = _b[dstXsunset] / r(mean);
											
};


esttab using `fileloc'/regs/crimes_dind.tex, 
	keep(dst*)
	replace
	stats(N, fmt(%9.0fc) label("Obs"))
	$esttab_opts;
		
estout using `fileloc'/regs/crimes_dind.xls, 
	keep(dst*)
	cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
	replace
	stats(shareofmean N, fmt(%9.3f %9.2fc) label("Share of Mean" "Observations"))
	starlevels(* 0.10 ** 0.05 *** 0.01)	;	


eststo clear;

foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {;

	** Any crime occurrence (column 6);
	replace `crime'_combined = 1 if `crime'_combined > 0;	
	tab `crime'_combined;
	
	reg `crime'_combined dst dstXsunset sunset [aw = population], cluster(ori_cluster);
	eststo;

	sum `crime'_combined if year == 2005 | year == 2006 & sunset == 1 [aw = population];	
			
	estadd scalar priorweekmean = r(mean);
	estadd scalar shareofmean = _b[dstXsunset] / r(mean);			

};

esttab using `fileloc'/regs/crimes_dind_anycrime.tex, 
	keep(dst*)
	replace
	stats(N, fmt(%9.0fc) label("Obs"))
	$esttab_opts;
		
estout using `fileloc'/regs/crimes_dind_anycrime.xls, 
	keep(dst*)
	cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
	replace
	stats(shareofmean N, fmt(%9.3f %9.2fc) label("Share of Mean" "Observations"))
	starlevels(* 0.10 ** 0.05 *** 0.01)	;	



**********************;
**********************;
**********************;
** Replicate Appendix Table 1;
**********************;
**********************;
**********************;

** Regressions as RD;
use `fileloc'/data/maindata.dta if rdcontinuous >= -21 & rdcontinuous <= 20 & modehour ~= 0, clear;	

foreach crime in rate_robbery {;
	replace `crime' = `crime'_combined;
};

keep if hour == 16 | hour == 17 | hour == 18 | hour == 19 | hour == 20;

xi i.dow;

xtset ori_by_year;

tempfile rdregs;
save `rdregs';

eststo clear;

foreach hour in 16 17 18 19 20 {;

	xtreg rate_robbery _I* `weather' running_day running_dayint dst [aw = population] if hour == `hour', cluster(ori_cluster) fe;
		
	_eststo;

};

esttab, 
	stats(N, fmt(%9.0fc) label("Total Observations"))
	keep(dst) $esttab_opts;

	estout using `fileloc'/regs/rd_by_clock_hour.xls, 
		keep(dst)
		cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
		replace
		stats(N, fmt(%9.0fc) label("Total Observations"))
		starlevels(* 0.10 ** 0.05 *** 0.01);
		
	esttab using `fileloc'/regs/rd_by_clock_hour.tex, 
		keep(dst)
		replace
		stats(N, fmt(%9.0fc) label("Total Observations"))
		$esttab_opts;

eststo clear;
		


**********************;
**********************;
**********************;
** Replicate Appendix Table 2;
**********************;
**********************;
**********************;	
** Hourly loop focuses on sunset hours, daily on full day results;
foreach outcome in hourly daily {;

	foreach crime in rate_robbery {;

		eststo clear;	
		** Regressions as RD;
		use `fileloc'/data/maindata.dta if rdcontinuous >= -7*8 & rdcontinuous <= 7*8 & modehour ~= 0, clear;	

		gen rdsq = running_day^2;
		gen rdintsq = running_dayint^2;
		gen rdcu = running_day^3;
		gen rdintcu = running_dayint^3;
		gen weekofyear = week(offdate);

		tempfile rd_robust_regs;
		save `rd_robust_regs';
		
		if "`outcome'" == "hourly" {;
			keep if cleaned_hours == 0 | cleaned_hours == 1;
		};
		
		collapse (sum) `crime'_combined (mean) `weather' running_day running_dayint dst population ori_cluster dow rd* year, by(ori_by_year offdate) fast;

		**Basic repetition;
		xi i.dow, noomit;

		areg `crime'_combined _I* `weather' running_day running_dayint dst [aw = population] if rdcontinuous >= -21 & rdcontinuous <= 20, cluster(ori_cluster) absorb(ori_by_year);
		eststo;

		xi i.dow, noomit;
		** Robustness 2: Change BW;
		** 2 weeks;
		areg `crime'_combined _I* `weather' running_day running_dayint dst [aw = population] if rdcontinuous >= -14 & rdcontinuous <= 13, cluster(ori_cluster) absorb(ori_by_year); 
		eststo;

		** 8 weeks;
		areg `crime'_combined _I* `weather' running_day running_dayint rdsq rdintsq rdcu rdintcu dst [aw = population] if rdcontinuous >= -54 & rdcontinuous <= 53, cluster(ori_cluster) absorb(ori_by_year); 
		eststo;

		** Robustness 3: add week of year impacts;
		gen weekofyear = week(offdate);
		xi i.weekofyear, prefix(_wk);
		areg `crime'_combined _I* _wk* `weather' running_day running_dayint dst if rdcontinuous >= -21 & rdcontinuous <= 20, cluster(ori_cluster) absorb(ori_by_year);
		eststo;

		** Robustness 4: unweighted;
		areg `crime'_combined _I* `weather' running_day running_dayint dst if rdcontinuous >= -21 & rdcontinuous <= 20, cluster(ori_cluster) absorb(ori_by_year);
		eststo;

		** Robustness 6: Only large population areas1 (cut lower 50% and 75% – approx 25,000 and 50,000);
		egen minpop = min(population), by(ori_cluster);
		sum minpop, d;
		gen lower50 = minpop < r(p50);
		gen lower75 = minpop < r(p75);

		areg `crime'_combined _I* `weather' running_day running_dayint dst if rdcontinuous >= -21 & rdcontinuous <= 20 & lower50 ~= 1,
	 cluster(ori_cluster) absorb(ori_by_year);
		eststo;		

		areg `crime'_combined _I* `weather' running_day running_dayint dst if rdcontinuous >= -21 & rdcontinuous <= 20 & lower75 ~= 1,
	 cluster(ori_cluster) absorb(ori_by_year);
		eststo;		
		
		esttab, 
			keep(dst) 
			$esttab_opts
			mtitles("Baseline" "2 Weeks" "8 Weeks (cubic)" "WoY FE" "Unweighted" "Upper 50% Pop" "Upper 25");

		estout using `fileloc'/regs/robustness_`crime'_`outcome'.xls, 
			keep(dst)
			cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
			replace
			stats(shareofmean N, fmt(%9.2f) label("Share of Mean"))
			starlevels(* 0.10 ** 0.05 *** 0.01);
		
		esttab using `fileloc'/regs/robustness_`crime'_`outcome'.tex,
			replace
			keep(dst) 
			$esttab_opts
			mtitles("Baseline" "2 Weeks" "8 Weeks (cubic)" "WoY FE" "Unweighted" "Upper 50% Pop" "Upper 25");

	};

};
	


**********************;
**********************;
**********************;
** Replicate Appendix Table 3;
**********************;
**********************;
**********************;
local crimesused "rate_robbery rate_rape rate_aggassault rate_murder";

** Regressions as RD;
use `fileloc'/data/maindata.dta if modehour ~= 0, clear;	

gen weekofyear = week(offdate);

** Combine attempted and successful;
foreach crime in `crimesused'  {;
	replace `crime' = (`crime'_combined);
};

collapse (sum) `crimesused' (mean) population year dow month ori_cluster `weather' fips rdcontinuous weekofyear, by(ori_by_year offdate) fast;

** Generate running day variable for false DST;
gen fake_rdcontinuous = rdcontinuous - (6*7);
gen fake_running_day = fake_rdcontinuous;
replace fake_running_day = 0 if fake_rdcontinuous > 0;
gen fake_running_dayint = fake_rdcontinuous;
replace fake_running_dayint = 0 if fake_rdcontinuous < 0;
gen fake_dst = 0;
replace fake_dst = 1 if fake_rdcontinuous >= 0;
keep if fake_rdcontinuous >= -21 & fake_rdcontinuous <= 20;
tab fake_dst;

tempfile rdregs;
save `rdregs';

eststo clear;		
foreach crime in `crimesused' {;
	
	use `rdregs', clear;
		
	xi i.dow, noomit;
	
	areg `crime' _Idow* `weather' fake_dst fake_running_day fake_running_dayint [aw = population], cluster(ori_cluster) absorb(ori_by_year);
	_eststo;

};
				
esttab, 
	keep(fake_dst) $esttab_opts;		

estout using `fileloc'/regs/daily_sixweeksearly.xls, 
	keep(fake_dst)
	cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
	replace
	starlevels(* 0.10 ** 0.05 *** 0.01)
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"));
	
esttab using `fileloc'/regs/daily_sixweeksearly.tex, 
	keep(fake_dst)
	replace
	$esttab_opts
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"));

** Regressions as RD;
use `fileloc'/data/maindata.dta if modehour ~= 0, clear;	

foreach crime in `crimesused'  {;
	replace `crime' = (`crime'_combined);
};

gen weekofyear = week(offdate);

collapse (sum) `crimesused' (mean) population year  dst dow month running_day running_dayint ori_cluster `weather' fips rdcontinuous weekofyear, by(ori_by_year offdate) fast;

gen fake_rdcontinuous = rdcontinuous + (6*7);
gen fake_running_day = fake_rdcontinuous;
replace fake_running_day = 0 if fake_rdcontinuous > 0;
gen fake_running_dayint = fake_rdcontinuous;
replace fake_running_dayint = 0 if fake_rdcontinuous < 0;
gen fake_dst = 0;
replace fake_dst = 1 if fake_rdcontinuous >= 0;
keep if fake_rdcontinuous >= -21 & fake_rdcontinuous <= 20;
tab fake_dst;

tempfile rdregs;
save `rdregs';

eststo clear;		
foreach crime in `crimesused' {;
	
	use `rdregs', clear;
		
	xi i.dow, noomit;
	
	areg `crime' _Idow* `weather' fake_dst fake_running_day fake_running_dayint [aw = population], cluster(ori_cluster) absorb(ori_by_year);
	_eststo;

};
				
esttab, 
	keep(fake_dst) $esttab_opts;		

estout using `fileloc'/regs/daily_sixweekslate.xls, 
	keep(fake_dst)
	cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
	replace
	starlevels(* 0.10 ** 0.05 *** 0.01)
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"));
	
esttab using `fileloc'/regs/daily_sixweekslate.tex, 
	keep(fake_dst)
	replace
	$esttab_opts
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"));


**********************;
**********************;
**********************;
** Replicate Appendix Table 4;
**********************;
**********************;
**********************;
local crimesused "rate_robbery";

** Regressions as RD;
use `fileloc'/data/maindata.dta if rdcontinuous >= -21 & rdcontinuous <= 20 & modehour ~= 0, clear;	

** Combine attempted and successful;
foreach crime in `crimesused' {;
	replace `crime' = `crime'_combined;
};

keep if cleaned_hours >= -18;

** Combine into two-hour chunks;
gen roundedhour = floor(cleaned_hours/2);
sum roundedhour;
local min = r(min);
local max = r(max);

collapse (sum) `crimesused' (mean) dow	`weather' running_day running_dayint dst population ori_cluster rdcontinuous, by(roundedhour ori_by_year offdate) fast;

xi i.dow;

xtset ori_by_year;

tempfile rdregs;
save `rdregs';

eststo clear;

forvalues hour = `min'(1)`max' {;

	xtreg rate_robbery _I* `weather' running_day running_dayint dst [aw = population] if roundedhour == `hour', cluster(ori_cluster) fe;
	
	_eststo;
	
};

	esttab, 
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"))
	keep(dst) $esttab_opts;

	estout using `fileloc'/regs/rd_allhours.xls, 
		keep(dst)
		cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
		replace
		starlevels(* 0.10 ** 0.05 *** 0.01);
	
	esttab using `fileloc'/regs/rd_allhours.tex, 
		keep(dst)
		replace
		$esttab_opts;

eststo clear;
	
	
	
	

**********************;
**********************;
**********************;
** Replicate Appendix Table 5, Panel A;
**********************;
**********************;
**********************;
local crimesused "rate_robbery rate_rape rate_aggassault rate_murder";

use `fileloc'/data/maindata.dta if modehour ~= 0, clear;	

** Combine attempted and successful;
foreach crime in `crimesused'  {;
	replace `crime' = (`crime'_combined);
};

gen dayofyear = doy(offdate);

gen keep_for_end = 0;
gen end_dst = 0;
foreach year in 2005 2006 2007 2008 {;
	replace end_dst = 1 if year == `year' & offdate < `laterdst`year'';
	replace keep_for_end = 1 if year == `year' & offdate >= `laterdst`year'' - 21 & offdate <= `laterdst`year'' + 20; 
};

keep if keep_for_end == 1;

** Running day equivalent;
drop running_day*;
gen running_day = 0;
gen running_dayint = 0;
foreach year in 2005 2006 2007 2008 {;
	replace running_day = offdate - `laterdst`year'' if year == `year';
	replace running_day = 0 if running_day > 0;
	replace running_dayint = offdate - `laterdst`year'' if year == `year';
	replace running_dayint = 0 if running_day < 0;
};		

collapse (sum) `crimesused' (mean) population year  dow month running_day running_dayint ori_cluster `weather' fips rdcontinuous end_dst, by(ori_by_year offdate) fast;

tempfile rdregs;
save `rdregs';

eststo clear;		
foreach crime in `crimesused' {;
	
	use `rdregs', clear;

	xi i.dow, noomit;
	
	** Add dow;
	areg `crime' _Idow* `weather' end_dst running_day running_dayint [aw = population], cluster(ori_cluster) absorb(ori_by_year);
	_eststo;
								
esttab, 
	keep(end_dst) $esttab_opts;		

estout using `fileloc'/regs/daily_end.xls, 
	keep(end_dst)
	cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
	replace
	starlevels(* 0.10 ** 0.05 *** 0.01)
	mlabels("Basic" "Add Weather" "Add Pop" "Add Year FE" "Add DoW FE")
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"));
	
esttab using `fileloc'/regs/daily_end.tex, 
	keep(end_dst)
	replace
	$esttab_opts
	mlabels("Basic" "Add Weather" "Add Pop" "Add Year FE" "Add DoW FE")
	stats(N priorweekmean shareofmean, fmt(%9.0fc %9.2f %9.2f) label("Total Observations" "Share of Mean"));

};



**********************;
**********************;
**********************;
** Replicate Appendix Table 5, Panel B;
**********************;
**********************;
**********************;
local crimesused "rate_robbery rate_rape rate_aggassault rate_murder";

use `fileloc'/data/maindata.dta if modehour ~= 0, clear;	

** Combine attempted and successful;
foreach crime in `crimesused'  {;
	replace `crime' = (`crime'_combined);
};


gen dayofyear = doy(offdate);

gen keep_for_end = 0;
gen end_dst = 0;
foreach year in 2005 2006 2007 2008 {;
	replace end_dst = 1 if year == `year' & offdate < `laterdst`year'';
	replace keep_for_end = 1 if year == `year' & offdate >= `laterdst`year'' - 21 & offdate <= `laterdst`year'' + 20; 
};

keep if keep_for_end == 1;

** Running day equivalent;
drop running_day*;
gen running_day = 0;
gen running_dayint = 0;
foreach year in 2005 2006 2007 2008 {;
	replace running_day = offdate - `laterdst`year'' if year == `year';
	replace running_day = 0 if running_day > 0;
	replace running_dayint = offdate - `laterdst`year'' if year == `year';
	replace running_dayint = 0 if running_day < 0;
};		

collapse (sum) rate* (mean) `weather' dow running_day running_dayint end_dst population ori_cluster year rdcontinuous, by(ori_by_year offdate) fast;

** Replace count with binary occurrence;
foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {;
	replace `crime' = 1 if `crime'_combined > 0;
};

eststo clear;
	
xi i.dow;

xtset ori_by_year;
		
eststo clear;
	
foreach crime in rate_robbery rate_rape rate_aggassault rate_murder {;

	xtreg `crime' _I* `weather' running_day running_dayint end_dst, fe cluster(ori_cluster);
		
	eststo;
};

	esttab, keep(end_dst);
	
	esttab using `fileloc'/regs/anycrime_day_end.tex, 
		keep(end_dst)
		replace
		stats(shareofmean, fmt(%9.2f) label("Share of Mean"))
		$esttab_opts;

	estout using `fileloc'/regs/anycrime_day_end.xls, 
		keep(end_dst)
		cells(b(fmt(%9.3f) star) se(fmt(%9.3f))) 
		replace
		stats(N, fmt(%9.0fc))
		starlevels(* 0.10 ** 0.05 *** 0.01);















