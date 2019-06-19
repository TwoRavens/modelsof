#delimit;
clear;
set more off;

global temp /Sastemp;
global path ~;
set mem 5000m;

capture log close;
log using $path/pollution/logfiles/industries.log, replace;

/*================================================
 Program: industries.do
 Author:  Avi Ebenstein
 Created: August 2007
=================================================*/
  
*==========================================================;
* Beginning of Province-level output code                  ;
*==========================================================;

insheet using $path/research/pollution/dumping/outputdata.csv,clear;
gen provnum=0;
replace provnum=11 if province=="Beijing";
replace provnum=12 if province=="Tianjin";
replace provnum=13 if province=="Hebei";
replace provnum=14 if province=="Shanxi";
replace provnum=15 if province=="Inner Mongolia";
replace provnum=21 if province=="Liaoning";
replace provnum=22 if province=="Jilin";
replace provnum=23 if province=="Heilongjiang";
replace provnum=31 if province=="Shanghai";
replace provnum=32 if province=="Jiangsu";
replace provnum=33 if province=="Zhejiang";
replace provnum=34 if province=="Anhui";
replace provnum=35 if province=="Fujian";
replace provnum=36 if province=="Jiangxi";
replace provnum=37 if province=="Shandong";
replace provnum=41 if province=="Henan";
replace provnum=42 if province=="Hubei";
replace provnum=43 if province=="Hunan";
replace provnum=44 if province=="Guangdong";
replace provnum=45 if province=="Guangxi";
replace provnum=46 if province=="Hainan";
replace provnum=50 if province=="Chongqing";
replace provnum=51 if province=="Sichuan";
replace provnum=52 if province=="Guizhou";
replace provnum=53 if province=="Yunnan";
replace provnum=54 if province=="Tibet";
replace provnum=61 if province=="Shaanxi";
replace provnum=62 if province=="Gansu";
replace provnum=63 if province=="Qinghai";
replace provnum=64 if province=="Ningxia";
replace provnum=65 if province=="Xinjiang";

sort year provnum;
gen tyear=substr(year,3,6);
drop year;
destring tyear, gen(year);
drop if year<1950|year>2006;
replace provnum=51 if provnum==50;
collapse (sum) gross_output,by(provnum year);

label var gross_output "Gross industrial output value (100 million yuan)";
label data "Industrial output from the China Data Center by province X year";

drop if year<1970;
sort provnum year;

* expand missing obs for 3 provinces without data for post 1970, 44, 46, 51;
expand 5 if year==1970 & (provnum==44|provnum==46|provnum==51);
sort provnum year;
bysort provnum year: replace year=1970+_n-1 if year==1970 & (provnum==44|provnum==46|provnum==51);
expand 3 if year==1975 & (provnum==44|provnum==46|provnum==51);
sort provnum year;
bysort provnum year: replace year=1975+_n-1 if year==1975 & (provnum==44|provnum==46|provnum==51);
sort provnum year;
save ~/pollution/industries/datafiles/outputdata.dta, replace;

*==========================================================;
* End of Province-level output code                        ;
*==========================================================;

********************;
* Clean each census ;
********************;

*=============;
* 1982 Census ;
*=============;

use ~/data/china/china1982/gis1982/historical/CH_CENSUS1982.dta, replace;
rename P82001 totpop;
rename P82002 density;
rename P82003 sexratio;
rename P82004 medianage;
rename P82005 pct_0_14;
rename P82006 pct_65_over;
rename P82007 pct_fem_15_49;
rename P82008 birthrate;
rename P82009 deathrate;
rename P82010 imr;
rename P82011 collegerate;
rename P82012 middlerate;
rename P82013 illiterate;
rename P82014 farmingshare_totemp;
rename P82015 indshare_totemp;
rename P82016 empshare_totpop;
rename P82017 income_percapita;

label var totpop "Total population";
label var density "Persons per sq km";
label var sexratio "Males per 100 Females";
label var medianage "Median age";
label var pct_0_14 "Percentage of total population aged 0-14";
label var pct_65_over "Percentage of total population 65 and over";
label var pct_fem_15_49 "Percentage of women aged 15-49 to total population";
label var birthrate "Birth rate per 1000, 1981";
label var deathrate "Death rate per 1000, 1981";
label var imr "Infant mortality rate per 1000, 1981";
label var collegerate "Number of college students per 10,000";
label var middlerate "Number of junior/middle school education per 10,000";
label var illiterate "Percentage of illiterate/semi-literate of population aged 12 and above(unit:.1%)";
label var farmingshare_totemp "Percentage of population in farming, forestry, animal husbandry, and fishery to total employed population";
label var indshare_totemp "Percentage of industrial population to total employed population";
label var empshare_totpop "Percentage of employed population to total population";
label var income_percapita "Gross average industrial and agricultural output per capita";

* Industrial workers = (ind pop/emp pop)*(emp pop/tot pop) *tot pop;
gen indpop=indshare_totemp*empshare_totpop*totpop;
label var indpop "Total industrial population";

bysort CNTYGB: keep if _n==1;
bysort PROVGB: egen indpop_tot=sum(indpop);
gen indshare=indpop/indpop_tot;
drop if PROVGB==71|PROVGB==81|PROVGB==82;
sort CNTYGB;
save ~/pollution/industries/datafiles/census1982, replace;

*=============;
* 1990 Census ;
*=============;

use ~/data/china/china1990/gis1990/historical/CH_CENSUS1990_PARTA.dta, replace;
gen indpop=A90088;
label var indpop "Workers in production and transportation (Unit: person)";
bysort CNTYGB: keep if _n==1;
bysort PROVGB: egen indpop_tot=sum(indpop);
gen indshare=indpop/indpop_tot;
drop if PROVGB==71|PROVGB==81|PROVGB==82;
sort CNTYGB;
save ~/pollution/industries/datafiles/census1990, replace;

*=============;
* 2000 Census ;
*=============;

use ~/data/china/china2000/gis2000/historical/CH_CENSUS2000.dta, replace;
rename L2000167 prod_transport_emp;
rename L2000177 indpop;
bysort CNTYGB: keep if _n==1;

/* Dump Chongqing into Sichuan */
replace PROVGB=51 if PROVGB==50;
bysort PROVGB: egen indpop_tot=sum(prod_transport_emp);
gen indshare=prod_transport_emp/indpop_tot;
drop if PROVGB==71|PROVGB==81|PROVGB==82;
sort CNTYGB;
save ~/pollution/industries/datafiles/census2000, replace;

*******************************************************;
* Creation of county X year measure of output for 1982 ;
*******************************************************;

use ~/pollution/industries/datafiles/County_centroids_watersheds_1982, clear;
gen CNTYGB=cntygb;
drop if CNTYGB>=710000;

sort CNTYGB;
merge CNTYGB using ~/pollution/industries/datafiles/census1982;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

expand 36;
bysort CNTYGB: gen year=1970+_n-1;
/* Hainan is not in the census yet, so _merge==2 */
gen provnum=PROVGB;
sort provnum year;
merge provnum year using ~/pollution/industries/datafiles/outputdata.dta;
tab _merge if year>=1970 & year<=2005;
tab _merge;
keep if _merge==1|_merge==3;
gen county_output=indshare*gross_output;

save ~/pollution/industries/datafiles/indtemp1982, replace;

*******************************************************;
* Creation of county X year measure of output for 1990 ;
*******************************************************;

use ~/pollution/industries/datafiles/County_centroids_watersheds_1990, clear;
gen CNTYGB=cntygb;
drop if CNTYGB>=710000;

sort CNTYGB;
merge CNTYGB using ~/pollution/industries/datafiles/census1990;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

expand 36;
bysort CNTYGB: gen year=1970+_n-1;
/* Hainan is not in the census yet, so _merge==2 */
gen provnum=PROVGB;
sort provnum year;
merge provnum year using ~/pollution/industries/datafiles/outputdata.dta;
tab _merge if year>=1970 & year<=2005;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;
gen county_output=indshare*gross_output;

save ~/pollution/industries/datafiles/indtemp1990, replace;

*******************************************************;
* Creation of county X year measure of output for 2000 ;
*******************************************************;

use ~/pollution/industries/datafiles/County_centroids_watersheds_2000, clear;
keep gbcode fid_1 id gbcnty provgb citygb eprov ecity ecnty level* et_x et_y;
gen CNTYGB=gbcnty;
drop if CNTYGB>=710000;

sort CNTYGB;
merge CNTYGB using ~/pollution/industries/datafiles/census2000;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

expand 36;
bysort CNTYGB: gen year=1970+_n-1;
gen provnum=PROVGB;
sort provnum year;
merge provnum year using ~/pollution/industries/datafiles/outputdata.dta;
tab _merge if year>=1970 & year<=2005;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;
gen county_output=indshare*gross_output;

save ~/pollution/industries/datafiles/indtemp2000, replace;

*******************************************************;
* Creation of basin-level output using each census     ;
*******************************************************;

global yearlist "1982 1990 2000";
foreach j of global yearlist{;
use ~/pollution/industries/datafiles/indtemp`j', replace;

forvalues i=1/6{;
                preserve;
collapse (sum) output=county_output (mean) PROVGB (mean) CNTYGB, by(level`i' year);
rename output output`i';
save ~/pollution/industries/datafiles/output_level`i'_`j'_only, replace;
                restore;
              };
                           };

*******************************************************;
* Combine the river basin data to form one data set    ;
*******************************************************;

global yearlist "1982 1990 2000";
foreach j of global yearlist{;
use ~/pollution/industries/datafiles/indtemp`j', replace;

if `j'==1982{;
             keep if year>=1970 & year<=1985;
           };
if `j'==1990{;
             keep if year>=1986 & year<=1995;
           };
if `j'==2000{;
             keep if year>=1996 & year<=2005;
           };
                             
forvalues i=1/6{;
                preserve;
collapse (sum) output=county_output (mean) PROVGB (mean) CNTYGB, by(level`i' year);
rename output output`i';
save ~/pollution/industries/datafiles/output_level`i'_`j', replace;
                restore;
              };
                           };
clear;
set obs 1;
gen censusyear=.;
forvalues i=1/6{;
append using ~/pollution/industries/datafiles/output_level`i'_1982;
replace censusyear=1982 if censusyear==.;                
append using ~/pollution/industries/datafiles/output_level`i'_1990;
replace censusyear=1990 if censusyear==.;                
append using ~/pollution/industries/datafiles/output_level`i'_2000;
replace censusyear=2000 if censusyear==.;
sort level`i' year;                
save ~/pollution/industries/datafiles/output_level`i'_historical, replace;
                clear;
set obs 1;
gen censusyear=.;

              };
       
exit;

********************************;
* END ;
********************************;
