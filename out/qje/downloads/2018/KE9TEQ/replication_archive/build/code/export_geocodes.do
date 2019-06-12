/*
** last changes: February 2015  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/

#delim;
clear all;
set more off;
capture log close;
set matsize 11000;
set maxvar 32767;
version 14;
set logtype text;
pause on;
set seed 301184;



/**********************************************************
***
***		"EXPORT ADDRESSES TO BE READ INTO ARCGIS"
***
**********************************************************/;


global PATH "F:\projects\advertising\RD";
global PATHdata "F:\projects\advertising\RD\data";
global PATHcode "F:\projects\advertising\RD\code";
global PATHlogs "F:\projects\advertising\RD\logs";

local st "C:\Program Files\StatTransfer12-64\st.exe";

global STATES "GA MA WY OH AL AR CA CO DE FL HI IA ID IL IN KS KY LA MD ME MN MO MS MT ND NH NJ NM NV OK OR MI NY NC ND PA RI SC SD TN UT VA WA WV WI AK AZ CT DC GA NE TX VT";


cd $PATHcode;

log using $PATHlogs/export.txt, replace;

*** export geocodes (which come from SAS) to be used in ArcGIS;
foreach s in $STATES {;

	di "STATE: `s'";
	
	
	use "$PATHdata/temp/`s'_addresses_geocoded.dta", clear;
	
	duplicates tag id, generate(dummy);
	assert dummy==0;
	drop dummy;
	
	rename y latitude;
	rename x longitude;
	keep latitude longitude _matched_ _status_ _score_ id;
	
	compress;
	
	local N=ceil(_N/1000000);
	
	forvalues o=1(1)`N' {;
	
		preserve;
		
		keep if _n>(`o'-1)*1000000 & _n<=`o'*1000000;
		
		save "$PATHdata/GISinput/`s'_file`o'.dta", replace;
		
		restore;
	
	};

};


*winexec `st' convert_dta_dbf.stcmd;

log close;