*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
*************************************************************************

************************
* buildMortalityCounts.do
** READ IN THE RAW MORTALITY DATA FROM 1959 TO 1978, MAKING SOME CHANGES ALONG THE WAY;
	MERGE SOME STATE AND COUNTY FIPS CODES ;
	THEN THIS DATA IS COLLAPSED AND APPENDED TOGETHER;
************************

#delimit;
set mem 1500m;
set more off;
set linesize 200;
disp "DateTime: $S_DATE $S_TIME";

******************************************************************************************************;
* PROGRAM THAT READS IN THE MORTALITY DATA ;
******************************************************************************************************;

program define readDaMortData ;
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	di " 	BEGIN MORTALITY DATA PREP FOR FILE `2'			";
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	local year = `1';

* data input: publically available mortality data;

	shell cp '2'.gz tempfile.txt.gz;
	shell gunzip tempfile.txt.gz;
	clear;
	infix '3'.dct;
	shell \rm tempfile.txt;
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	di " 		JUST READ IN FILE `2'			";
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	summ;;
	**********************************************************************************************;
	* HERE WE HAVE A BUNCH OF CHANGES THAT ARE DIFFERENT ACROSS YEARS. ;
	**********************************************************************************************;
	if `1' <= 61 {;
		* county was only allocated as two digits in 1959-61 since some states have 
			more than 99 counties, need to recode;
		replace res_county = res_county + 100 if res_state5961rec==61|
    			res_state5961rec==63|res_state5961rec==65|res_state5961rec==67|
    			res_state5961rec==69|res_state5961rec==71|res_state5961rec==74;
		replace res_county = res_county + 200 if res_state5961rec==72;
		};
	if `1' <= 66 {;
  		* in the 1959-1966 data files the trichotomous race code has: 2=other, 3=black
			swap the other and black codes to match other years here; 
 		gen black = race_tri==3;
  		replace race_tri = 3 if race_tri==2;
  		replace race_tri = 2 if black==1;
  		drop black;
		};
	if `1' <= 68 | `1' == 73 {;
		* in some files the death_icd variable comes in two parts make it look like 
			the other years for consistency;
		if `1' ~= 68 & `1' ~= 73 {;
			* ALPHANUMERIC ;
	  		replace death_icd4="0" if death_icd4=="-";
	  		destring death_icd4, replace;
			};
		if `1' == 68 | `1' == 73 {;
			* NUMERIC;
  			replace death_icd4=0 if death_icd4==.;
			};
  		gen death_icd = (death_icd123+death_icd4/10)*100;
  		drop death_icd123 death_icd4;
		};
	* FUDGING WITH THE YEAR. IM SURPRISED IS SO DIFFERENT ACROSS FILES. ;
	if `1' == 67 | `1' == 68 {;
		replace year = year + 1960;
		};
	if `1' == 73 {;
		replace year = year + 1970;
		};
	if (`1' >= 69 & `1' <= 72) | (`1' >= 74 & `1' <= 78) {;
		replace year = year + 1900;
		}; 
	* IT LOOKS LIKE SOME COO COO BANNANNAS HEAD MADE COUNTY AND CITY A STRING. ;
	if `1' == 73 {;
		drop if res_county=="ZZZ";
  		destring res_county, replace;
  		drop if res_city=="ZZZ";
  		destring res_city, replace;
		};

	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	di " 	AFTER DOING SOME CROSS YEAR STANDARDIZATION `2'	";
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	summ;

	**********************************************************************************************;
	* HERE I PUT SOME RESTRICTIONS ON THE DATA;
	**********************************************************************************************;
	* in 1975 there are 11 people from Maine that die in counties not in Maine perhaps 
		these guys are from Massachusetts, but it's unclear, drop them since there 
		are only 16 counties in Maine. for some reason all of their year is ==1970 
		(in the 1975 file);
  	drop if year==1970 & res_state==20 & res_county>16;
	* DROP THOSE WHO ARE LISTED AS NONRESIDENT ALIENS. DOESNT MATTER FOR YEARS PRIOR TO 68;
	if `1' ~= 67 {;
		drop if res_status == 4;
		};
	* KEEP ONLY INFANTS - WHICH MEANS THOSE WHO ARE LESS THAN ONE YEAR OLD. ;
	drop if (age_det>=1 & age_det<=199) | age_det==999;
	* KEEP ONLY WHITES AND BLACKS ;
	*drop if race_tri==3;

	**********************************************************************************************;
	* GENERATE SOME VARIABLES ;
	**********************************************************************************************;
	* FOR SOME REASON WE ONLY HAVE A 50% SAMPLE OF MORTALITY FILES FOR 1972;
  	gen weight = 1;
	replace weight = 2 if year == 1972;
	* NEONATAL;
	gen neonatal=age_det>=301;
	* RACE ;
	gen white = (race_di==1);
	* GENDER ;
	gen female = sex==2;
	* causes of death are recorded to two decimal places broad categories are defined by the 
		first three digits;
	gen icd = death_icd/100;
	replace icd = int(icd);
	* generate age in months at time of death;
	gen age_month = 0 if age_det>211;
	replace age_month = age_det-200 if age_det<=211;
	* THIS LOOKS WEIRD BUT THIS DOES GENERATE THE BIRTH MONTH ;
	gen bmonth = 12 - (age_month - month);
	replace bmonth = bmonth - 12 if bmonth>12;
	* BIRTH YEAR ;
	gen byear = year;
	replace byear = year-1 if age_month>=month;

	**********************************************************************************************;
	* HERE IS THE ALL IMPORTANT PLACE WHERE WE DEFINE OUTCOMES. ;
	* outcome1 = all (1-16);
	* outcome2 = possibly nutrition (def 1) cod1-cod5;
	* outcome3 = not outcome2 cod6-cod16;
	* outcome4 = possibly nutrition (def 2) cod1-cod10;
	* outcome5 = not outcome4 cod11-cod16;
	* outcome6 = accidents cod15;
	**********************************************************************************************;
	foreach cause of numlist 1(1)16 {;
		gen byte bcod`cause'=0;
	};
	***********************************;
	* 1959-1967 definitions (ICD-7);
	***********************************;
	replace bcod1 = 1 if icd>=750 & icd<=759 & year<=1967;
	replace bcod2 = 1 if icd==773 & year<=1967;
	replace bcod3 = 1 if icd==776 & year<=1967;
	replace bcod4 = 1 if icd==53 & year<=1967;
	replace bcod5 = 1 if ((icd>=480&icd<=483) | (icd>=490&icd<=493) | icd==763) & year<=1967;
	replace bcod6 = 0 if year<=1967; * bcod 6 not recorded before 1968;
	replace bcod7 = 1 if icd==762 & year<=1967;
	replace bcod8 = 1 if icd==761 & year<=1967;
	replace bcod9 = 1 if ((icd>=45&icd<=48) | icd==543 | icd==571 | icd==572 | icd==764) & year<=1967;
	replace bcod10 = 1 if ((icd>=400&icd<=402) | (icd>=410&icd<=443)) & year<=1967;
	replace bcod11 = 0 if year<=1967; * bcod 11 not recorded before 1968;
	replace bcod12 = 1 if (icd>=800&icd<=962) & year<=1967;
	replace bcod13 = 1 if icd==760 & year<=1967;
	replace bcod14 = 1 if icd==770 & year<=1967;
	replace bcod15 = 1 if icd>=800 & icd<=999 & year<=1967;
	replace bcod16 = 1 if 	bcod1==0&bcod2==0&bcod3==0&bcod4==0&bcod5==0&bcod6==0&
				bcod7==0&bcod8==0&bcod9==0&bcod10==0&bcod11==0&bcod12==0&
				bcod13==0&bcod14==0&bcod15==0 & year<=1967;
	***********************************;
	* 1968-1978 definitions (ICD-8);
	***********************************;
	replace bcod1 = 1 if (icd>=740 & icd<=759) & year>=1968;
	replace bcod2 = 1 if (death_icd==77610 | death_icd==77620) & year>=1968;
	replace bcod3 = 1 if icd==777 & year>=1968;
	replace bcod4 = 1 if icd==38 & year>=1968;
	replace bcod5 = 1 if ((icd>=470&icd<=474) | (icd>=480&icd<=486)) & year>=1968;
	replace bcod6 = 1 if 	((death_icd>=76900&death_icd<=76920) |
				death_icd==76940 | death_icd==76950 |
				death_icd==76990) & year>=1968;
	replace bcod7 = 1 if (death_icd==77690) & year>=1968;
	replace bcod8 = 1 if (icd==770 | icd==771) & year>=1968;
	replace bcod9 = 1 if (icd==4 | (icd>=6&icd<=9) | icd==535 | icd==561 | icd==563) & year>=1968;
	replace bcod10 = 1 if ((icd>=390&icd<=398) | icd==402 | icd==404 | (icd>=410&icd<=429)) & year>=1968;
	replace bcod11 = 1 if death_icd==79500 & year>=1968;
	replace bcod12 = 1 if (icd>=800 & icd<=949) & year>=1968;
	replace bcod13 = 1 if ((icd>=764&death_icd<=76830) | icd==772) & year>=1968;
	replace bcod14 = 1 if (icd==774 | icd==775) & year>=1968;
	replace bcod15 = 1 if icd>=800 & icd<=999 & year>=1968;
	replace bcod16 = 1 if 	bcod1==0&bcod2==0&bcod3==0&bcod4==0&bcod5==0&bcod6==0&
				bcod7==0&bcod8==0&bcod9==0&bcod10==0&bcod11==0&bcod12==0&
				bcod13==0&bcod14==0&bcod15==0& year>=1968;

	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	di " 		AFTER RESTRICTIONS AND MAKING NEW VARS `2'	";
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	summ;

	**********************************************************************************************;
	* NOW LETS ADD WHAT WAS FORMALLY CALLED THE FIPS SUBROUTINE. THIS ADDS THE FIPS CODES
		TO THE STATES AND COUNTIES. NOTE THAT ANKUR HAS RECREATED THE CROSSWALK FOR YEARS
		PRIOR TO 1968. ;
	**********************************************************************************************;
	rename res_state nstate;
	rename res_county ncnty`1';
	rename res_city ncity`1';
	sort nstate ncnty`1' ncity`1';
	save temp, replace;
	clear;
	* PRIOR TO 68 WE HAD TO CONSTRUCT OUR OWN CROSSWALK. AFTER 1968 WE BORROWED A VERY WELL 
		CONSTRUCTED CROSSWALK. CITY DATA IS NOT VERY GOOD BEFORE 1968 SO IM GOING TO LEAVE 
		IT OUT. ;
	if `1' >= 68 {;
		use mortcw.dta;
		keep stfips countyfips nstate ncnty`1' ncity`1';
		drop if ncnty$year==-99|ncity$year==-99;
		sort nstate ncnty`1' ncity`1';
		merge nstate ncnty`1' ncity`1' using temp;
		};
	if `1' < 68 {;
		use pre68mortcw.dta;
		keep stfips countyfips nstate ncnty`1' ;
		drop if nstate == . | ncnty`1' == . ;
		sort nstate ncnty`1';
		merge nstate ncnty`1' using temp;
		};
	tab _merge;
	keep if _merge == 3;
	drop _merge;

	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	di " 		AFTER MERGE WITH FIPS DATA `2'	";
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	summ;

	**********************************************************************************************;
	* NOW WE SAVE TWO TYPES OF FILES. BEFORE THE COLLAPSE AND AFTER THE COLLAPSE WHERE WE
		SUM THESE OUTCOMES BY YEAR MONTH STATE COUNTY RACE AND GESTATION. ;
	**********************************************************************************************;
	sort byear bmonth stfips countyfips white race_tri neonatal;
	collapse (sum) bcod* [pweight=weight], by(byear bmonth stfips countyfips white race_tri neonatal);
	compress;
	save mortANKUR19`1', replace;

	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
	di " 		END MORTALITY DATA PREP FOR FILE `2'			";
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";

	clear;
	shell rm temp.dta;
	end;

******************************************************************************************************;
* FIRST WE NEED TO PREP THE COUNTY CITY CROSSWALK FILE. ;
******************************************************************************************************;
* Mortality crosswalk, from Doug Almond ;
use mort_cwalk.dta;
rename fstate stfips;
rename fcounty countyfips;
drop if countyfips == -99;
qui do countyfix.do;
save mortcw.dta, replace;
clear;

* Creating a crosswalk for pre-68 ;
insheet nstate ncnty59 ncnty60 ncnty61 ncnty62 ncnty63 ncnty64 ncnty65 ncnty66 ncnty67 fips
	using /3310/research/foodstamps/vitals_mortality/cwalk/cwalkpre68/cwalkpre68.txt;
gen stfips = int(fips/1000);
gen countyfips = fips-stfips*1000;
drop fips;
save pre68mortcw.dta, replace;
clear;

******************************************************************************************************;
* THIS ISNT REALLY A NEW SECTION BUT I AM USING THE PROGRAM DEFINED ABOVE, readDaData  
	TO READ IN THE MORTALITY DATA ;
******************************************************************************************************;

* input data: publically available mortality data;
*	http://www.nber.org/data/vital-statistics-compressed-mortality-data.html;

forvalues j = 59(1)61 {;
	readDaMortData "`j'" "Mort`j'" "mort5961";
	};
forvalues j = 62(1)66 {;
	readDaMortData "`j'" "Mort`j'" "mort6266";
	};
readDaMortData "67" "Mort67" "mort67";
readDaMortData "68" "mort68.dat" "mort68";
foreach j of numlist 69(1)72 74(1)78 {;
	readDaMortData "`j'" "mort19`j'.txt" "mort6978";
	};
readDaMortData "73" "mort1973s.txt" "mort73";
clear;

******************************************************************************************************;
* TIME TO MAKE US SOME FLIPPEN COHORTS!! ;
******************************************************************************************************;

use mortANKUR1959.dta;
forvalues x = 60(1)78 {;
	append using mortANKUR19`x';
	};
summ;
sort byear bmonth stfips countyfips white race_tri neonatal;
collapse (sum) bcod*, by(byear bmonth stfips countyfips white race_tri neonatal);
rename byear year;
rename bmonth month;
compress;
sort year month stfips countyfips white race_tri neonatal;
save mortalityCounts, replace;

di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
di " 		THE END RESULT			";
di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%";
summ;

******************************************************************************************************;
* LEARN YOUR MANNERS!!!! CLEAN UP!!!!! ;
******************************************************************************************************;
/*
cd $myDir;
shell rm mortcw.dta;
shell rm pre68mortcw.dta;
forvalues x = 59(1)78 {;
	shell rm mortANKUR19`x'.dta;
	};
*/
disp "DateTime: $S_DATE $S_TIME";
clear;

