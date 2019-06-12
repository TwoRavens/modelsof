#delimit;
version 13;
set more off;
clear all;
pause on;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using tables2&3&4.log, text replace;


/****************************************************************************************************************************/
/*     	File Name:	tables2&3&4.do						                													*/
/*     	Date:   	September 14, 2017																						*/
/*      Authors: 	Olga Chyzh and Elena Labzina																			*/
/*      Purpose:	Make Tables 2-4 for "Bankrolling Repression? Modeling Third-Party Influence on Protests and Repression" */
/*      Input Files: WCRWreplication.dta, posttenure_fate.dta    															*/
/****************************************************************************************************************************/

/*Open replication data for Chenoweth and Stepan (2011)*/
use "WCRWreplication.dta", clear;
replace byear=1983 if lccode==840 & byear==1986; /*The original dataset must have accidentally switched eyear and byear for this one observation*/
replace eyear=1986 if lccode==840 & eyear==1983;
/*Table 2: Overt Support for the Government by a Third-Party State During a Protest Campaign, 1899-2006*/
tab regaid regviol, row chi;

/*Open data on post-tenure fate of leaders who received support from a third-party:*/
import delimited using "posttenure_fate.csv", clear;	
/*Table 3: Post-Tenure Fate of Protege Leaders, 1899-2006*/
tab fate if removal==1;

/*Generate variables "safe" and "era"*/
gen safe=(fate=="exile" | fate=="stayed");
replace safe=. if (fate=="natural death" | fate=="assassinated");
gen era=(eyear>1989);

/*Table 4: Third Party Type and Post-Tenure Fate of Protege Leaders, 1899-2006*/
bysort era: tab third_party safe if removal==1 & !missing(fate);

log close;

