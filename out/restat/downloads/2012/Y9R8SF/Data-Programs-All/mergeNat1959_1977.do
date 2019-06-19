#delimit;
drop _all;
set mem 500m;
set linesize 200;
set more off;
disp "DateTime: $S_DATE $S_TIME";

***************************************************************************************************;
* THIS PROGRAM DOES WHAT MERGENAT.DO DOES, ONLY WITH A FEW CHANGES. THE ORIGINAL MERGENAT JUST 
	MERGED THE NATALITY DATA TO THE FOODSTAMP AND CROSS WALK FILES USING COUNTIES. WE WOULD 
	LIKE TO ADD DATA FROM PRIOR TO 1968, BUT THAT IS ONLY AVAILABLE AT THE STATE LEVEL. ;
***************************************************************************************************;

***************************************************************************************************;
* FIRST MAKE THE NATALITY DATA FROM 1968+ INTO A STATE YEAR DATASET ;
***************************************************************************************************;
forvalues i=68(1)77 {;
	* THE STATE CODE AVAILABLE IN THE VITAL STATISTICS IS PROPRIETARY. NEED TO MERGE ON 
		SOME FIPS CODES ;
	di "&&&&&&&&&&&&&&&&&&&&&&& YEAR = 19`i' BEGIN &&&&&&&&&&&&&&&&&&&&&&&&";
	qui use /3310/research/foodstamps/vitals_natality/cwalk/nat_cwalk ;
	keep stfips countyfips nstate ncnty`i' ncity`i';
	drop if ncnty`i'==-99;
	duplicates drop;
	isid nstate ncnty`i' ncity`i';
	sort nstate ncnty`i' ncity`i';
	save /3310/research/foodstamps/vitals_natality/data_vitals/temp, replace;
	clear;
	qui use /3310/research/foodstamps/vitals_natality/data_vitals/natality/nattest19`i';
	
	*rename state and county to match cwalk var names;
	rename res_state nstate;
	rename res_county ncnty`i';
	rename res_city ncity`i';

	*drop counties w/out county vitals code (-99);
	drop if ncnty`i'==-99;
	sort nstate ncnty`i' ncity`i';

	* MERGE ON THE FIPS CODES ;
	merge nstate ncnty`i' ncity`i' using 
		/3310/research/foodstamps/vitals_natality/data_vitals/temp;
	tab nbirths if _merge!=3, missing;
	drop if _merge!=3;
	keep mom_race stfips countyfips year month nbirths bw* recordweight gest;
	rm /3310/research/foodstamps/vitals_natality/data_vitals/temp.dta;

	*set missing countyfips (-99) to "." ;
	replace countyfips=. if countyfips==-99;

	* WE NEED TWO TYPES OF COLLAPSES. ONE FOR 1968 TO CREATE THE FOOD STAMP PROGRAM TREATMENT VARIABLE,
		AND ONE FOR THE REST. THE FORMER WILL BE BY COUNTY MONTH STATE YEAR. THE LATER BY JUST 
		STATE AND YEAR. REMEMBER WE NEED 1968 IN THE OVERALL DATA AS WELL ;
	if `i' == 68 {;
		save /3310/research/foodstamps/vitals_natality/data_vitals/preserveDontWork;
		sort stfips countyfips year month;
		collapse (sum) nbirths [pweight=recordweight], by(stfips countyfips year month);
		save /3310/research/foodstamps/vitals_natality/data_vitals/FSPTemp`i', replace;
		clear;
		use /3310/research/foodstamps/vitals_natality/data_vitals/preserveDontWork;
		rm /3310/research/foodstamps/vitals_natality/data_vitals/preserveDontWork.dta;
		};

	* USING FENTON 2003 10TH PERCENTILE BABY WEIGHT THRESHOLDS BY GESTATION, WE WOULD LIKE TO 
		CALUCULATE THE SHARE OF BIRTHS BELOW THIS THRESHOLD. HERE WE CALCULATE IF A BABY
		IS BELOW THEIR THRESHOLD. ;
	local weeks 	"22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 
			37 38 39 40 41 42 43 44 45 46 47 48 49 50" ;
	local fentonThres "384.2395354 449.6508548 512.6903547 574.9594163 638.9963309 711.6076946 
			797.6180189 900.758318 1022.761453 1170.488991 1345.674452 1544.210478 
			1758.088963 1983.949777 2214.862238 2388.92344 2563.110487 2737.499501 
			2912.038504 3056.670053 3204.840915 3353.854733 3504.866505 3663.809379 
			3805.84609 3966.881744 4125.630093 4282.283863 4408.728515" ;
	gen fenton10th = .;
	label variable fenton10th "Share of births below Fenton 2003 10perc weight threshold";
	foreach j of numlist 1(1)29 {;
		local w : word `j' of `weeks';
		local t : word `j' of `fentonThres';
		replace fenton10th = 0 if gest == `w' & bweight > `t';
		replace fenton10th = 1 if gest == `w' & bweight <= `t';
		macro drop w t;
		};
	gen fentonMiss = (fenton10th == .);

	sort mom_race stfips year;
	collapse (sum) nbirths bw1500 bw2000 bw2500 bw3000 bw3500 bw4000 bw4500 fenton10th 
		fentonMiss [pweight=recordweight], by(mom_race stfips year);
	save /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp`i', replace;
	clear;
	di "&&&&&&&&&&&&&&&&&&&&&&& YEAR = 19`i' END &&&&&&&&&&&&&&&&&&&&&&&&";
	};
* NOW WE CAN STACK THE DATA WE CREATED ;
use /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp68;
forvalues i = 69(1)77 {;
	append using /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp`i';
	};
summ;
save /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp68_77, replace;
clear;



***************************************************************************************************;
* HILARY SUGGESTED A SUPERIOR WAY TO CONSTRUCT THE FSP VARIABLE. ;
/*
	-- take the foodstamps.dta file. Keep only fs_month, fs_year and
	county/state identifiers. (number of obs=number of counties)
	-- expand it so there is one observation for each year/month in 1959-1977
	(20 years x 12 months)
	-- create a new variable FSP=1 if FS in place in this
	state/county/month/year using the lag of 3 months. Here is code from
	reg_mainq:
	
	* fs start;
	gen time_fs = (fs_year-1968)*12 + fs_month;
	drop if time_fs ==.;
	* month of third trimester;
	gen time_third = (year-1968)*12 + month - 3;
	gen byte fsp = (time_fs<=time_third);
	label var fsp "fsp three months before birth month";

	-- now merge this state/county/year/month data with your counts of number of
	births in 1968 by state/county/month
	-- collapse to mean of FSP indicator at the state/year level where you use
	nbirths (at state/county/month in 1968) as weights
*/
***************************************************************************************************;
use /3310/research/foodstamps/peterwork/foodstamps/foodstamps, clear;
keep stfips countyfips fs_month fs_year countyname totalpop;
* THESE ARENT GOING TO BE USEFUL FOR US. ;
drop if fs_year == . | fs_month == .;
summ;
sort stfips countyfips fs_year fs_month;
save /3310/research/foodstamps/vitals_natality/data_vitals/temp, replace;
clear;

* CREATE A SKELETON FILE OF ALL COUNTIES IN THE FOOD STAMP PROGRAM THAT CONTAINS
	ALL YEARS AND MONTHS BETWEEN 1959 AND 1977. ;
use /3310/research/foodstamps/vitals_natality/data_vitals/temp;
keep stfips countyfips countyname totalpop;
sort stfips countyfips ;
duplicates drop stfips countyfips, force;
summ;
* CREATE YEARS ;
expand 19;
sort stfips countyfips;
by stfips countyfips: gen year = 1958 + _n;
* CREATE MONTHS ;
expand 12;
sort stfips countyfips year;
by stfips countyfips year: gen month = _n;
summ;

* NOW MERGE THE SKELETON FILE TO THE FOOD STAMP PROGRAM FILE;
sort stfips countyfips ;
merge stfips countyfips 
	using /3310/research/foodstamps/vitals_natality/data_vitals/temp,
	keep(stfips countyfips fs_year fs_month);
table _merge;
drop _merge;
* MAKE SURE EVERYONE GOT A FOODSTAMP MONTH AND YEAR ;
summ;
* NOW POPULATE THOSE TIME PERIODS AFTER THE FOOD PROGRAM WAS ESTABLISHED WITH ONES. ;
* fs start;
gen time_fs = (fs_year-1958)*12 + fs_month;
drop if time_fs ==.;
* month of third trimester;
gen time_third = (year-1958)*12 + month - 3;
gen byte fsp = (time_fs<=time_third);
label var fsp "fsp three months before birth month";
summ;
* TURN THIS OFF, JUST TO CHECK WHATS GOING ON. ;
*list in 1/2000;
sort stfips countyfips month;
save /3310/research/foodstamps/vitals_natality/data_vitals/temp, replace;
clear;

* NOW MERGE THE 1968 MICRO DATA BY STATE COUNTY AND MONTH ;
use stfips countyfips month nbirths 
	using /3310/research/foodstamps/vitals_natality/data_vitals/FSPTemp68;
summ;
drop if countyfips == .;
sort stfips countyfips month;
merge stfips countyfips month using /3310/research/foodstamps/vitals_natality/data_vitals/temp;
tab _merge;
*--------------------------------------------------------------------------;
* A QUICK ASIDE TO UNDERSTAND WHAT IS GOING ON BEHIND THE MERGE HERE ;
save /3310/research/foodstamps/vitals_natality/data_vitals/temp2, replace;
clear;
	* FIRST THOSE NOT MERGING IN THE MASTER DATA ;
	use /3310/research/foodstamps/vitals_natality/data_vitals/temp2;
	keep if _merge == 1;
	duplicates drop stfips countyfips, force;
	* 2 Alaska, 8 Colorado, 9 Connecticut, 50 Vermont, 56 Wyoming ;
	tabulate stfips;	
	clear;
	* NOW LETS CHECK OUT THOSE NOT MERGING IN THE USING DATA
		PRESENT IN FOODSTAMP DATA, BUT NOT IN 1968 MICRO DATA;
	use /3310/research/foodstamps/vitals_natality/data_vitals/temp2;
	keep if _merge == 2;
	* FROM THE EVIDENCE PRESENTED HERE, I THINK ITS REASONABLE TO ASSUME
		THAT SMALLISH COUNTIES DID NOT HAVE BIRTHS IN SOME MONTHS
		IN 1968. ;
	duplicates drop stfips countyfips month, force;
	* IN SOME MONTHS A FEW COUNTIES DID NOT HAVE ANY BIRTHS IN 1968;
	tab countyname month;	
	duplicates drop stfips countyfips, force;
	* THE COUNTIES THAT DID NOT HAVE ANY BIRTHS ARE SMALLISH. ;
	table countyname, c(sum totalpop);	
clear;
use /3310/research/foodstamps/vitals_natality/data_vitals/temp2;
rm /3310/research/foodstamps/vitals_natality/data_vitals/temp2.dta;
*--------------------------------------------------------------------------;
keep if _merge == 3;
sort stfips year;

* AND FINALLY COLLAPSE USING BIRTHS AS A WEIGHT. ;
collapse (mean) fsp [aw=nbirths], by(stfips year);
summ;
sort stfips year;
save /3310/research/foodstamps/vitals_natality/data_vitals/FSPStateYear, replace; 
rm /3310/research/foodstamps/vitals_natality/data_vitals/temp.dta;
* FOR FUN CHECKING ;
outsheet _all using /3310/research/foodstamps/vitals_natality/output/check/checkFSP59_77.out, replace;
clear;

***************************************************************************************************;
* LETS PUT TOGETHER THE DATA FOR THE PRE1968 PERIOD. ;
***************************************************************************************************;
insheet year stfips race bwtot bw0_10 bw0_5 bw5_10 bw10_15 bw15_20 bw20_25 bw25_30 bw30_35 
		bw35_40 bw40_45 bw45_50 bw50plus nwNotStated
	using /3310/research/foodstamps/vitals_natality/data_vitals/natality/BabyWeight4-30-08.txt;
keep if stfips > 0 & race > 0;
gen bw1500 = 0;
replace bw1500 = bw0_10 + bw10_15 if year <= 1963; 
replace bw1500 = bw0_5 + bw5_10 + bw10_15 if year > 1963; 
gen bw2000 = bw1500 + bw15_20;
gen bw2500 = bw2000 + bw20_25;
gen bw3000 = bw2500 + bw25_30;
gen bw3500 = bw3000 + bw30_35;
gen bw4000 = bw3500 + bw35_40;
gen bw4500 = bw4000 + bw40_45;
gen nbirths = bwtot;
gen nonwhite = 0;
replace nonwhite = 1 if race == 2;
keep stfips year nonwhite nbirths bw1500 bw2000 bw2500 bw3000 bw3500 bw4000 bw4500;
* THIS GETS RID OF JERSEY IN TWO YEARS ;
drop if bw1500 ==.;
summ;
save /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp59_67, replace;
clear;

***************************************************************************************************;
* THIS SECTION IS AN ASIDE AND CAN BE COMMENTED OUT MOST OF THE TIME. WHAT I WOULD LIKE TO CHECK
	IS THAT WHEN WE STACK THE PRE1968 AND 1968+ DATA, WE ARE USING THE CORRECT RACE VARIABLE.
	IN YEARS BEFORE 1968, WE HAVE WHITES AND NON-WHITES. IN YEARS AFTER, WE HAVE WHITES, NON
	WHITES AND BLACKS. ITS PRETTY OBVIOUS THAT IN POST YEARS WE SHOULD JUST BE ADDING BLACKS
	AND OTHERS, BUT WE ARE GOOD SOCIAL SCIENTISTS AND WE SHOULD ALWAYS CHECK IF WHAT WE ARE 
	DOING IS CORRECT. CAUSE, LETS BE HONEST, HOW MANY TIMES HAVE YOU LOOKED AT DATA AND IT 
	TURN OUT TO BE COMPLETELY WACKY AND COUNTERINTUITIVE???? ;
***************************************************************************************************;
program define checkOutRace ;
	use /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp68_77;
	gen nonwhite = 0 ;
	replace nonwhite = (`1');
	`2';	
	keep stfips nonwhite year nbirths;
	sort stfips nonwhite year;
	collapse (sum) nbirths , by(stfips nonwhite year);
	append using /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp59_67,
		keep(stfips nonwhite year nbirths);
	summ;
	sort year nonwhite ;
	collapse (mean) nbirths, by(year nonwhite);
	twoway 	scatter nbirths year if nonwhite == 1, connect(l) lc(gs0) ms(i) ||,
			legend(off) title("`3'") xline(1967) ylabel(9000(1000)13000)
			xtitle("Year") ytitle("Avg Births/State")
			graphregion(color(white) icolor(white));	
	graph export 
		/3310/research/foodstamps/vitals_natality/output/check/checkSeam59_77`3'.eps, replace;
	twoway 	scatter nbirths year if nonwhite == 0, connect(l) lc(gs0) ms(i) ||,
			legend(off) title("Whites (`3')") xline(1967)
			xtitle("Year") ytitle("Avg Births/State")
			graphregion(color(white) icolor(white));	
	graph export 
		/3310/research/foodstamps/vitals_natality/output/check/checkSeam59_77whites`3'.eps, replace;
	clear;
	end;
*checkOutRace "mom_race == 2" 	"" 	"Black_Only";
*checkOutRace "mom_race > 1" 	""	"Black_AND_Others";

***************************************************************************************************;
* I KNOW YOU DIDNT THINK THIS TIME WAS GOING TO COME, BUT NOW I CAN FINALLY STACK THE 
	1959 THROUGH 1977 DATA AND THEN WE CAN MERGE THE FOOD STAMP TREATMENT VAR. ;
***************************************************************************************************;
use /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp68_77;
* LETS ASSUME THAT NONWHITE IN THE PRE 1968 DATA IS BLACK + OTHER IN THE POST 1967 DATA ;
gen nonwhite = 0;
replace nonwhite = 1 if mom_race >1;
drop mom_race;
sort nonwhite stfips year;
collapse (sum) nbirths bw1500 bw2000 bw2500 bw3000 bw3500 bw4000 bw4500 fenton10th fentonMiss, 
	by(nonwhite stfips year);
* NOW APPEND THE MATCHIN DATA;
append using /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp59_67;
summ;
sort stfips year;
merge stfips year using /3310/research/foodstamps/vitals_natality/data_vitals/FSPStateYear ;
tab _merge;
* THOSE NOT MERGING HERE ARE ALL PART OF ALASKA. ;
tab stfips if _merge == 1;
keep if _merge == 3;
drop _merge;
summ;
sort stfips year nonwhite;
list stfips year nonwhite fsp in 1/100;

***************************************************************************************************;
* LABEL WHAT WE CAN ;
***************************************************************************************************;
  label var stfips	"State of Residence";
  label define statefiplbl 1 "Alabama", add;
  label define statefiplbl 2 "Alaska", add;
  label define statefiplbl 4 "Arizona", add;
  label define statefiplbl 5 "Arkansas", add;
  label define statefiplbl 6 "California", add;
  label define statefiplbl 8 "Colorado", add;
  label define statefiplbl 9 "Connecticut", add;
  label define statefiplbl 10 "Delaware", add;
  label define statefiplbl 11 "District of Columbia", add;
  label define statefiplbl 12 "Florida", add;
  label define statefiplbl 13 "Georgia", add;
  label define statefiplbl 15 "Hawaii", add;
  label define statefiplbl 16 "Idaho", add;
  label define statefiplbl 17 "Illinois", add;
  label define statefiplbl 18 "Indiana", add;
  label define statefiplbl 19 "Iowa", add;
  label define statefiplbl 20 "Kansas", add;
  label define statefiplbl 21 "Kentucky", add;
  label define statefiplbl 22 "Louisiana", add;
  label define statefiplbl 23 "Maine", add;
  label define statefiplbl 24 "Maryland", add;
  label define statefiplbl 25 "Massachusetts", add;
  label define statefiplbl 26 "Michigan", add;
  label define statefiplbl 27 "Minnesota", add;
  label define statefiplbl 28 "Mississippi", add;
  label define statefiplbl 29 "Missouri", add;
  label define statefiplbl 30 "Montana", add;
  label define statefiplbl 31 "Nebraska", add;
  label define statefiplbl 32 "Nevada", add;
  label define statefiplbl 33 "New Hampshire", add;
  label define statefiplbl 34 "New Jersey", add;
  label define statefiplbl 35 "New Mexico", add;
  label define statefiplbl 36 "New York", add;
  label define statefiplbl 37 "North Carolina", add;
  label define statefiplbl 38 "North Dakota", add;
  label define statefiplbl 39 "Ohio", add;
  label define statefiplbl 40 "Oklahoma", add;
  label define statefiplbl 41 "Oregon", add;
  label define statefiplbl 42 "Pennsylvania", add;
  label define statefiplbl 44 "Rhode island", add;
  label define statefiplbl 45 "South Carolina", add;
  label define statefiplbl 46 "South Dakota", add;
  label define statefiplbl 47 "Tennessee", add;
  label define statefiplbl 48 "Texas", add;
  label define statefiplbl 49 "Utah", add;
  label define statefiplbl 50 "Vermont", add;
  label define statefiplbl 51 "Virginia", add;
  label define statefiplbl 53 "Washington", add;
  label define statefiplbl 54 "West Virginia", add;
  label define statefiplbl 55 "Wisconsin", add;
  label define statefiplbl 56 "Wyoming", add;
  label values stfips statefiplbl;

***************************************************************************************************;
* HOW ARE WE DOING? IN PARTICULAR, HOW DO THE BIRTHS LOOK ACROSS YEAR 1968? ;
***************************************************************************************************;
summ;
save /3310/research/foodstamps/vitals_natality/data_vitals/natality59_77, replace;
* EXPORT ENTIRE DATASET FOR FACT CHECKING ; 
outsheet _all using /3310/research/foodstamps/vitals_natality/output/check/checkALL59_77.out, replace;
clear;


* CLEANUP ;
/*
forvalues i = 68(1)77 {;
	rm /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp`i'.dta;
	};
rm /3310/research/foodstamps/vitals_natality/data_vitals/FSPTemp68.dta;
rm /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp68_77.dta;
rm /3310/research/foodstamps/vitals_natality/data_vitals/natilTemp59_67.dta;
rm /3310/research/foodstamps/vitals_natality/data_vitals/FSPStateYear.dta ;
*/
disp "DateTime: $S_DATE $S_TIME";

