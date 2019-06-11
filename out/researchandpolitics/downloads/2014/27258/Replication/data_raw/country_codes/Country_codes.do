clear
set mem 500M				
set maxvar 32767
set more off
capture log close 
log using data.log, replace
set matsize 775 
#delimit ;

/*
***************************************************************************
File-Name:	Country_Codes.do		                        
Date:		Aug 11, 2008                                    
Author:		Fernando Martel                                 
Purpose:		Create data set of country code concordances	
Data Input:	C:\Documents and Settings\Fernando\My Documents\
			NYU_PhD\Country_codes\All agency country codes.xls
			 The file contains datacodes downloaded from the 
			 web istes of UN, WB, Petc.  Form that file we   
			 save UN, WB and ISO codes as CSV in  files		
			 named UN.csv, WB.csv and so on				
Output File:	country_codes.dta                               
Data Output:	Country code concordances                       
Previous file:	None                                            
Status:		In progress                                     
Machine:		IBM, X41 tablet                                 
**************************************************************************
*/

/*
PLEASE NOTE:													
In what follows we use UN as the standard setter and merge other codes 
onto it, even if some of the UN country names are not the official ones
We only expand on this set if UN does not have a code for an entitiy   
reported by another agency		
1993-07-28 (Newsletter III-45): Numeric code of Yugoslavia changed from 890 to 891
(a consequence of the splitting off of Bosnia and Herzegovina, Croatia, Macedonia, and Slovenia).					
On 3 June 2006, Serbia and Montenegro (numerical code 891) formally dissolved
 into 2 independent countries: Montenegro (numerical code 499) and Serbia (numerical code 688).	
2006-09-26 (Newsletter V-12): "Serbia and Montenegro", whose codes were CS, SCG, and 891,
 split into two countries: Serbia and Montenegro.		
*/

/**************************************************************************
SET FILE PATH
***************************************************************************/

cd "C:\Documents and Settings\Fernando\My Documents\NYU_PhD\Country_codes";


/**************************************************************************
STEP 1 --	IMPORT .CSV FILES WITH CONTRY NAMES AND CODES FROM THE VARIOUS 
		SOURCES.  THESE ARE DERIVED FROM 
		C:\Documents and Settings\Fernando\My Documents\NYU_PhD\Country_codes
		All Agency Countries codes.xls
***************************************************************************/

/*
STEP 1.1 -- Import UN country codes from .CSV files, label, sort, save as .dta
*/

insheet using "UN.csv";

*Trim leading and lagging spaces in all string variables*;
replace ctyname=trim(ctyname);
replace ctycode=trim(ctycode);

*rename variables*;
rename ctyname unctyname;
rename ctycodenum unctycodenum;

*Generate unctycode variable*;
gen unctycode=ctycode;

*Label data*;
label var unctyname "UN country name";
label var unctycodenum "UN country numerical code";
label var unctycode "UN country alpha-3 code";
label var ctycode "Comprehensive country code";
notes ctycode: Comprehensive list of entities and
 codes from UN, ISO3166-1 and ISO3166-3 alpha-3, and author;

*Sort data, save and clear memory*;
sort ctycode, stable;
save UN, replace;
clear;

/*
STEP 1.2 -- Import WB country codes from .CSV files, label, sort, save as .dta
*/

insheet using "WB.csv";

*For some reason it is importing headings as vars, delete and rename*;
drop if _n==1;
rename v1 wbctyname;
rename v2 ctycode;

*Trim leading and lagging spaces in all string variables*;
replace wbctyname=trim(wbctyname);
replace ctycode=trim(ctycode);
gen wbctycode=ctycode;

*Label data*;
label var wbctyname "World Bank country name";
label var wbctycode "World Bank country alpha-3 code";
label var ctycode "Comprehensive country code";
notes ctycode: Comprehensive list of entities and
 codes from UN, ISO3166-1 and ISO3166-3 alpha-3, and author;
notes wbctycode: World Bank claims to use ISO 3166-1 ALPHA-3, which is 
 true, but it does not keep up to the latest standard so they have 
 Romania as ROM instead of ROU, and so on;

*Sort data, save and clear memory*;
sort ctycode, stable;
save WB, replace;
clear;

/*
STEP 1.3 -- Import ISO country codes from .CSV files, label, sort, save as .dta
*/

insheet using "ISO.csv";

*For some reason it is importing headings as vars, delete and rename*;
drop if _n==1;
rename v1 isoctyname;
rename v2 isoctycode;
rename v3 ctycode;

*Trim leading and lagging spaces in all string variables*;
replace isoctyname=trim(isoctyname);
replace isoctycode=trim(isoctycode);
replace ctycode=trim(ctycode);

*Label data*;
label var isoctyname "ISO 3166-1 country name";
label var isoctycode "ISO 3166-1 ALPHA-3 country code";
label var ctycode "Comprehensive country code";
notes ctycode: Comprehensive list of entities and
 codes from UN, ISO3166-1 and ISO3166-3 alpha-3, and author;
notes isoctycode: ISO only provides ISO 3166-1 ALPHA-2 (2 letter country
 code) in its website.  Concordance to ALPHA-3 relies on the relation 
 reported in Wikipedia as of 8/14/08 http://en.wikipedia.org/wiki/ISO_3166-1;

*Sort data, save and clear memory*;
sort ctycode, stable;
save ISO, replace;
clear;


/*
STEP 1.4 -- Import Przeworski et al country codes from .CSV files, label, 
		  sort, save as .dta
*/

insheet using "PZ.csv";

*Trim leading and lagging spaces in all string variables*;
replace pzctyname=trim(pzctyname);
replace ctycode=trim(ctycode);

*Label data*;
label var pzctyname "Przeworski et al country name";
label var pzctycodenum "Przeworski et al country code";
label var ctycode "Comprehensive country code";
notes ctycode: Comprehensive list of entities and
 codes from UN, ISO3166-1 and ISO3166-3 alpha-3, and author;
notes pzctycodenum: Przeworski et al include entities that no longer exists,
 like USSR.  Where possible these have been coded using ISO3166-3, the 
 standard for obsolete entities, as reported in http://www.statoids.com/w3166his.html;

*Sort data, save and clear memory*;
sort ctycode, stable;
save PZ, replace;
clear;


/*
STEP 1.5 -- Import ihme et al country codes from .CSV files, label, sort, save as .dta
*/

insheet using "ihme.csv";

*For some reason it is importing headings as vars, delete and rename*;
drop if _n==1;
rename v1 ihmectyname;
rename v2 ctycode;

*Trim leading and lagging spaces in all string variables*;
replace ihmectyname=trim(ihmectyname);
replace ctycode=trim(ctycode);

*Label data*;
label var ihmectyname "Institute of Health Metrics country name";
label var ctycode "Comprehensive country code";
notes ctycode: Comprehensive list of entities and
 codes from UN, ISO3166-1 and ISO3166-3 alpha-3, and author;

*Sort data, save and clear memory*;
sort ctycode, stable;
save ihme, replace;
clear;

/**************************************************************************
STEP 2 --	MERGE ALL COUNTRY CODE DATASETS CREATED ABOVE INTO A SINGLE FILE
		country_codes.dta
***************************************************************************/

/*
STEP 2.1 -- Merge WB into UN and create country_codes.dta
*/

use UN;
merge ctycode using WB;

/*
Reorder variables to make analysis easier
*/

move  ctycode unctyname;
move  unctycodenum wbctyname;
move  unctycodenum wbctyname;

/*
NOTE: All WB entities and codes are a proper subset of UN.  However, they do 
not match do to different spellings or use of obsolete country codes by WB.
These include:	Andorra, Channel Islands, Isle of Man, Romania, Timor-Leste, 
West Bank and Gaza, Congo, Dem. Rep.
In what follows I move wbctycode and wbctyname to approriate UN ROW	.
One exception is Channel Islands, for whic UN reports numeric but not  
alphabetic code so I fill in ctycode using wbctycode				
*/

/*
Andorra
*/
replace wbctyname = "Andorra" if unctycodenum==20;
replace wbctycode="ADO" if unctycodenum==20;

/*
Channel Islands
*/
replace ctycode="CHI" if unctycodenum==830;
replace wbctyname="Channel Islands" if ctycode=="CHI";
replace wbctycode="CHI" if ctycode=="CHI"; 

/*
Isle of Man
*/
replace wbctyname="Isle of Man" if ctycode=="IMN";
replace wbctycode="IMY" if ctycode=="IMN"; 

/*
Romania
*/
replace wbctyname="Romania" if ctycode=="ROU";
replace wbctycode="ROM" if ctycode=="ROU"; 

/*
Timor-Leste
*/
replace wbctyname="Timor-Leste" if ctycode=="TLS";
replace wbctycode="TMP" if ctycode=="TLS"; 

/*
West Bank and Gaza
*/
replace wbctyname="West Bank and Gaza" if ctycode=="PSE";
replace wbctycode="WBG" if ctycode=="PSE"; 

/*
Congo, Dem. Rep.
*/
replace wbctyname="Congo, Dem. Rep." if ctycode=="COD";
replace wbctycode="ZAR" if ctycode=="COD";

/*
Create master cty name variable
*/
gen ctyname=unctyname;
label var ctyname "Comprehensive country name";
notes ctyname: Comprehensive list of country names 
 from UN, ISO3166-1 alpha-2 and ISO3166-3 alpha-3, and author;

/*
Drop excess WB data, sort and save
*/
drop if _merge==2;
drop _merge;
order ctycode ctyname;
sort ctycode, stable;
save country_codes, replace;


/*
STEP 2.2 -- Merge ISO into country_codes.dta
*/

/*
NOTE: ISO alpha-2 contains a host of small islands not in UN Alpha-3. 
In ohter words, UN alpha-3 is a proper subset of ISO alpha-2.  Hence, 
I add these to the comprehensive variables ctycode and ctyname. Note 
ISO alpha-2 also includes Taiwan
*/

merge ctycode using ISO;
replace ctyname=isoctyname if _merge==2;
drop _merge;

sort ctycode, stable;
save country_codes, replace;
 
/*
STEP 2.3 -- Merge Przeworski et al concordance into country_codes.dta
*/
/*
NOTE: PZ includes countries that no longer exist, such as CZE and USSR
where possible I have used the old alpha-3 codes for these entities as
decribed in http://www.statoids.com/w3166his.html
*/

merge ctycode using PZ;
replace ctyname=pzctyname if _merge==2;
replace ctyname="Serbia and Montenegro" if ctycode=="SCG";
drop _merge;

sort ctycode, stable;

/*
STEP 2.4 -- Merge Institute of Health Metrics concordance into country_codes.dta
*/
merge ctycode using ihme;
tab _merge;   //All 3s and 1s ok
drop _merge;

sort ctycode, stable;

/**************************************************************************
STEP 3 --	LABEL AND SAVE DATASET country_codes.dta
***************************************************************************/
label data "Data dictionary of country codes";
notes: Source for UN codes: United Nations Statistics Division - Countries 
 or areas, codes and abbreviations web site accessed 8/12/08 
 http://unstats.un.org/unsd/methods/m49/m49alpha.htm ;
notes: Source for ISO codes: For ISO3166-1 alpha-2 ISO website accessed 8/12/08 
 http://www.iso.org/iso/country_codes/iso_3166_code_lists/english_country_names_and_code_elements.htm
 For concordance with ISO3166-1 Alpha-3 I used a concordance from Wikipedia accessed 8/12/08 
 http://en.wikipedia.org/wiki/ISO_3166-1 ;
notes: Source for World Bank codes: Web site accessed 8/12/08 http://go.worldbank.org/K2CKM78CC0 ;
notes: Source for Przeworski et al: REG02.xls downloaded from Przeworski's NYU web site on 2/10/08
 http://politics.as.nyu.edu/object/przeworskilinks.html For obsolete entities I tried to use ISO3166-3, 
 the standard for obsolete entities, as reported in http://www.statoids.com/w3166his.html , otherwise
 made my own code.;
notes: Source for  Institute of Health Metrics child mortality data: CMRestimates.xls downloaded
 downloaded 24/7/09 from http://www.healthmetricsandevaluation.org/resources/datasets.html;


save country_codes, replace;
log close;
exit;
