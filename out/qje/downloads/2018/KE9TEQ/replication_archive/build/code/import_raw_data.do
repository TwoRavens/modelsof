/*
** last changes: July 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
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
***		IMPORT RAW VOTER REGISTRATION DATA
***
**********************************************************/;


global PATH "F:\projects\advertising\RD";
global PATHdata "F:\projects\advertising\RD\data";
global PATHcode "F:\projects\advertising\RD\code";
global PATHlogs "F:\projects\advertising\RD\logs";

global STATES "AK AL AR AZ CA CO CT DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MT MS NC ND NE NJ NH NM NV NY OH OK OR PA RI SD SC TN TX UT VA VT WV WA WI WY DC";


cd $PATHcode;


/* *** DATA IMPORT *** */;

log using $PATHlogs/import.txt, replace;

* import states' raw voter registration lists;
foreach s in $STATES {;
	clear;
	
	di "STATE: `s'";
	
	quietly:  infile using $PATHcode/data_dictionary.dct, using($PATHdata/raw/`s'.txt);
	

	* create unique voter ID;
	gen ID=upper(STATE)+string(_n,"%11.0g");
	duplicates tag ID, generate(dummy);
	assert dummy==0;
	drop dummy; 
	
	
	assert substr(ID,1,2)=="`s'"; 
	
	
	* clean zip codes;
	gen residential_zip4=substr(residential_zip,1,5)+"-"+substr(residential_zip,6,4) if length(residential_zip)==9;
	replace residential_zip=substr(residential_zip,1,5);
	replace residential_zip="" if length(residential_zip)!=5;
	destring residential_zip, replace force;
	
	if "`s'"=="NH" {;
		replace dob="";
		replace registered=ltrim(rtrim(changed));
	};
	
	* save voters' address (to be used for geocoding);
	export delimited ID residential_street1 residential_street2 residential_city residential_state residential_zip residential_zip4 residential_county using "$PATHdata/temp/addresses/`s'_adresses.csv", quote replace;
	
	* save vote history and basic voter characteristics;
	keep ID STATE dob registered race gender party general_201* general_200* primary*_201* primary*_200*;
	

	
	compress;
	save "$PATHdata/temp/`s'_vh.dta", replace;
	
};

log close;
