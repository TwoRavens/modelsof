/*
** last changes: March 2018  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/

#delim;
clear all;
set more off;
capture log close;
set matsize 11000;
set maxvar 32767;
version 14.2;
set logtype text;
pause off;
set seed 301184;



/**********************************************************
***
***		CLEAN AND ASSEMBLE RAW VOTER REGISTRATION DATA
***
**********************************************************/;


global PATH "F:\projects\advertising\RD";
global PATHdata "F:\projects\advertising\RD\data";
global PATHcode "F:\projects\advertising\RD\code";
global PATHlogs "F:\projects\advertising\RD\logs";

global GRPfile "R:/Dropbox/research/advertising_paper/analysis/input/grps.dta";

global GRPs "oth_ptyd_base ptyd_base ptya_base"; 
global SEGS "5k 10k 20k";
global STUBS "r_vote_ r_vote_prev_primary_ r_vote_prev_midterm_ r_vote_next_midterm_ r_registered_ r_Mregistered_ DISTRICT_ r_D_ptyd_base_ r_D_ptya_base_ r_ptyd_base_gap_ r_ptya_base_own_ r_ptyd_base_own_ r_oth_ptyd_base_own_ r_MD_ptyd_base_ r_MD_ptya_base_";


global STATES "AL AR AZ CA CO CT DE FL GA IA ID IL IN KS KY LA MA MD ME MI MN MO MT MS NC ND NE NJ NM NV NY OH OK OR PA RI SD SC TN TX UT VA VT WA WV WI WY DC NH";
/* note: we don't have any within-state media market borders for AK and HI */;
*local nAK = 1;   
local nAL = 4;
local nAR = 2;
local nAZ = 4;
local nCA = 18;
local nCO = 4;
local nCT = 3;
local nDC = 1;
local nDE = 1;
local nFL = 12;
local nGA = 7;
*local nHI = 1;
local nIA = 2;
local nID = 1;
local nIL = 9;
local nIN = 5;
local nKS = 2;
local nKY = 4;
local nLA = 3;
local nMA = 5;
local nMD = 5;
local nME = 2;
local nMI = 8;
local nMN = 4;
local nMO = 5;
local nMS = 3;
local nMT = 1;
local nNC = 8;
local nND = 1;
local nNE = 2;
local nNH = 1;
local nNJ = 6;
local nNM = 2;
local nNV = 2;
local nNY = 16;
local nOH = 8;
local nOK = 3;
local nOR = 3;
local nPA = 9;
local nRI = 1;
local nSD = 1;
local nSC = 3;
local nTN = 5;
local nTX = 15;
local nUT = 2;
local nVA = 6;
local nVT = 1;
local nWA = 7;
local nWI = 6;
local nWV = 2;
local nWY = 1;



cd $PATHcode;



log using $PATHlogs/clean.txt, replace;


/* *** ASSEMBLE DATA *** */;

*** ArcGIS FID to DMA crosswalk;
tempfile fid_dma_crosswalk;
clear;
import delimited $PATHdata\crosswalks\FIDtoDMA.csv;

save `fid_dma_crosswalk';

*** FIPS to DMA crosswalk;
tempfile fips_dma_crosswalk;
clear;
import delimited $PATHdata\crosswalks\fips_dma.csv;
duplicates drop fips, force;
save `fips_dma_crosswalk';


*** GRPs;
tempfile grps_2012;
tempfile grps_2008;
use $GRPfile, clear;

preserve;
keep if year==2012;
keep dma_code cmag_oth_ptyd_base cmag_prez_ptyd_base cmag_prez_ptya_base;

rename cmag_oth_ptyd_base oth_ptyd_base;
rename cmag_prez_ptyd_base ptyd_base;
rename cmag_prez_ptya_base ptya_base;
 
compress;
save `grps_2012';

restore;
keep if year==2008;
keep dma_code cmag_oth_ptyd_base cmag_prez_ptyd_base cmag_prez_ptya_base;

rename cmag_oth_ptyd_base oth_ptyd_base;
rename cmag_prez_ptyd_base ptyd_base;
rename cmag_prez_ptya_base ptya_base;

compress;
save `grps_2008';



*** merge ArcGIS output with vote histories & ad measures;
foreach s in $STATES {;

	tempfile temp`s';
	
	clear;
	
	di "STATE: `s'";
	
	forvalues f=1(1)`n`s'' {;
	
		append using "$PATHdata/GISoutput/`s'_all_file`f'.dta";
	
	};
	
	drop objectid;
	gen statefp="";
	gen	countyfp="";
	
	forvalues f=1(1)`n`s'' {;

	merge 1:1 id using "$PATHdata/GISoutput/`s'_county_file`f'.dta", keepusing(statefp countyfp) update;
	assert _merge==1 | _merge==4 | _merge==3;
	drop _merge;

	};
	
	foreach q in $SEGS {;
	
		forvalues f=1(1)`n`s'' {;

		merge 1:1 id using "$PATHdata/GISoutput/`s'_`q'_file`f'.dta", keepusing(objectid) update;
		assert _merge==1 | _merge==4 | _merge==3;
		drop _merge;

		};
		
		rename objectid SEGMENT_`q';
	
	};
	
	forvalues f=1(1)`n`s'' {;

	merge 1:1 id using "$PATHdata/temp/`s'_district_file`f'con111.dta", keepusing(district) update;
	assert _merge==1 | _merge==4 | _merge==3;
	drop _merge;

	};
	rename district district_2008;
	
	forvalues f=1(1)`n`s'' {;

	merge 1:1 id using "$PATHdata/temp/`s'_district_file`f'con113.dta", keepusing(district) update;
	assert _merge==1 | _merge==4 | _merge==3;
	drop _merge;

	};
	rename district district_2012;
	
	
	keep distance A_MATCHED_ A_STATUS_ id LEFT_FID RIGHT_FID ID_1 statefp countyfp district* SEGMENT*;
	
	rename id ID;
	rename A_MATCHED_ GISmatched;
	rename ID_1 DMAown;
	rename statefp state;
	rename countyfp county;
	rename district_2012 DISTRICT_2012;
	rename district_2008 DISTRICT_2008;
	
	
	destring DMAown, replace;
	destring state, replace;
	destring county, replace;
	
	merge m:1 county state using "$PATHdata\temp\sigviewed_counties.dta", keepusing(sigviewed);
	drop if _merge==2;
	drop _merge;

	rename sigviewed r_sigviewed;
	replace r_sigviewed=0 if mi(r_sigviewed);
	
	
	*** vote histories;
	merge 1:1 ID using $PATHdata/temp/`s'_vh.dta;
	assert _merge==3;
	drop _merge;
	
	replace STATE=upper(STATE);
	
	
	***  add measures & DMA codes;
	rename LEFT_FID fid;
	merge m:1 fid using `fid_dma_crosswalk', keepusing(dma_code);
	drop if _merge==2;
	drop _merge;
	replace dma_code=. if DMAown==dma_code;
	drop fid;

	rename RIGHT_FID fid;
	merge m:1 fid using `fid_dma_crosswalk', keepusing(dma_code) update;
	drop if _merge==2;
	drop _merge;
	rename dma_code DMAother;
	drop fid;
	
	forvalues y=2008(4)2012 {;
		rename DMAother dma_code;
		merge m:1 dma_code using `grps_`y'', keepusing($GRPs);
		drop if _merge==2; drop _merge;
		rename dma_code DMAother;
		foreach v in $GRPs {;
			rename `v' r_`v'_other_`y';
		};
		rename DMAown dma_code;
		merge m:1 dma_code using `grps_`y'', keepusing($GRPs);
		drop if _merge==2; drop _merge;
		rename dma_code DMAown;
		foreach v in $GRPs {;
			rename `v' r_`v'_own_`y';
		};
	};
	
	
	
	
/* *** CLEAN DATA *** */; 
	
	* recode distance into "directional" measure based on sign of "GRP difference";
	forvalues y=2008(4)2012 {;	
		foreach grp in ptyd_base ptya_base {;
			gen r_D_`grp'_`y'=distance*(r_`grp'_own_`y'>r_`grp'_other_`y') - distance*(r_`grp'_own_`y'<r_`grp'_other_`y') if distance>0;
			gen r_MD_`grp'_`y'=0;
			replace r_MD_`grp'_`y'=1 if r_`grp'_own_`y'==r_`grp'_other_`y' | distance<=0 | mi(r_`grp'_other_`y') | mi(r_`grp'_own_`y');
			replace r_D_`grp'_`y'=0 if r_MD_`grp'_`y'==1;
			assert (r_D_`grp'_`y'==0 & r_MD_`grp'_`y'==1) | (r_D_`grp'_`y'!=0 & r_MD_`grp'_`y'==0);
		};
		
		gen r_ptyd_base_gap_`y'=r_ptyd_base_own_`y'-r_ptyd_base_other_`y';

	
	drop r*_other_`y';
	};
	
	* voted in 2008 & 2012 general elections;
	gen r_vote_2008 =(general_2008!="");
	gen r_vote_2012 =(general_2012!="");
	
	* voted in previous midterm elections;
	gen r_vote_prev_midterm_2008 =(general_2006!="");
	gen r_vote_prev_midterm_2012 =(general_2010!="");
	
	* voted in next midterm elections;
	gen r_vote_next_midterm_2008 =(general_2010!="");
	gen r_vote_next_midterm_2012 =(general_2014!="");
	
	* voted in previous primaries;
	gen r_vote_prev_primary_2008 =(primary_2008!="");
	gen r_vote_prev_primary_2012 =(primary_2012!="");
	
	* party;
	gen r_dem=(party=="1");
	gen r_rep=(party=="2");
	gen r_other_none=(party!="1" & party!="2");
	
	* source of party info;
	gen r_partyinfo_none=(STATE=="AL" | STATE=="HI" | STATE=="MI" | STATE=="MO" | STATE=="MN" | STATE=="MT" | STATE=="ND" | STATE=="VT" | STATE=="WA" | STATE=="WI");
	gen r_partyinfo_state=(STATE=="AK" | STATE=="AR" | STATE=="AZ" | STATE=="CA" | STATE=="CO" | STATE=="CT" | STATE=="DC" | STATE=="DE" | STATE=="FL" | STATE=="GA" | STATE=="IA" | STATE=="ID" | STATE=="KS" | STATE=="KY" | STATE=="MA" | STATE=="IL" | STATE=="LA" | STATE=="MD" | STATE=="ME" | STATE=="IN" | STATE=="MS" | STATE=="NC" | STATE=="NE" | STATE=="NH" | STATE=="NJ" | STATE=="NM" | STATE=="NV" | STATE=="NY" | STATE=="OH" | STATE=="OK" | STATE=="OR" | STATE=="PA" | STATE=="RI" | STATE=="SD" | STATE=="TN" | STATE=="TX" | STATE=="UT" | STATE=="WV" | STATE=="WY");
	gen r_partyinfo_primary=(STATE=="SC" | STATE=="VA");
	assert (r_partyinfo_none + r_partyinfo_state + r_partyinfo_primary)==1;
	
	*** gender, race and age;
	gen r_Mfemale=0;
	replace r_Mfemale=1 if !((gender=="F" | gender=="f") | (gender=="M" | gender=="m"));
	gen r_female=(gender=="F" | gender=="f");
	
	gen dummy=substr(dob,1,4);
	destring dummy, replace force;
	gen r_age=2008-dummy;
	gen r_Mage=0;
	replace r_Mage=1 if mi(dummy) | dummy<1900 | dummy>2000 | r_age<18 | r_age>112;
	replace r_age=0 if r_Mage==1;
	assert !mi(r_age);
	drop dummy;
	
	*** voter registration date;
	gen dummy=substr(registered,1,4);
	destring dummy, replace force;
	forvalues y=2008(4)2012 {;
		gen r_registered_`y'=(dummy<=`y');
		gen r_Mregistered_`y'=0;
		replace r_Mregistered_`y'=1 if mi(dummy) | dummy<1900 | dummy>2015;
		replace r_registered_`y'=0 if r_Mregistered_`y'==1;
		assert r_registered_`y'==0 | r_registered_`y'==1;
	};
	
	gen r_house_tenure=2012-dummy;
	gen r_Mhouse_tenure=0;
	replace r_Mhouse_tenure=1 if mi(dummy) | dummy<1920 | dummy>2012;
	replace r_house_tenure=0 if r_Mhouse_tenure==1;
	assert !mi(r_house_tenure);
	drop dummy;

	
	** clean GISvariables;
	gen r_matched_none=(GISmatched=="None");
	gen r_matched_city=(GISmatched=="City") | (GISmatched=="2 cities");
	gen r_matched_zip=(GISmatched=="ZIP");
	gen r_matched_street=(GISmatched=="Street");
	assert (r_matched_none + r_matched_city + r_matched_zip + r_matched_street)==1;
		
	

	gen r_distance=distance if distance>0;
	gen r_Mdistance=(distance<=0);
	replace r_distance=0 if r_Mdistance==1;
	assert r_distance>=0;
	
	keep ID DISTRICT* SEGMENT* STATE DMAown DMAother r_*;
	
	reshape long $STUBS, i(ID) j(YEAR);

	foreach stub in $STUBS {;
		
		local l = strlen("`stub'") -1;
		local vname = substr("`stub'",1,`l');
		rename `stub' `vname';
		
	};

	
	compress;
	save `temp`s'';

};


*** append files to nationwide voter registration list;
clear;
foreach s in $STATES {;
	
	append using `temp`s'';
	
};
drop if r_Mregistered==1 | r_Mdistance==1;

* recreate ID variable;
egen long dummy=group(ID); drop ID;
gen long ID=dummy; drop dummy;


* border segment ID;
gen dummy1=DMAown*(DMAown>DMAother) + DMAother*(DMAown<DMAother);
gen dummy2=DMAown*(DMAown<DMAother) + DMAother*(DMAown>DMAother);
egen BORDER=group(dummy1 dummy2 STATE);
egen BORDER_PARTY=group(BORDER r_dem r_rep);
egen BORDER_PARTY_YEAR=group(BORDER_PARTY YEAR);
drop dummy*;

foreach q in $SEGS {;
	egen BORDER_`q'=group(SEGMENT_`q' STATE);
	egen BORDER_`q'_PARTY=group(BORDER_`q' r_dem r_rep);
	egen BORDER_`q'_PARTY_YEAR=group(BORDER_`q'_PARTY YEAR);
};
drop SEGMENT*;

egen CDfe = group(STATE DISTRICT);
drop DISTRICT;
egen CD_BORDER_10k_PARTY=group(BORDER_10k_PARTY CDfe);
egen CD_BORDER_10k_PARTY_YEAR=group(BORDER_10k_PARTY_YEAR CDfe);
drop CDfe;

compress;

count;



save $PATHdata/voterpanel.dta, replace;







