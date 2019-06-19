*************************************************************************
* makenat5967.do							*
*									*
* Imputes birth counts by race*county*month*year			*
* a.  read in Doug's data by race*county*year				*
* b.  read in Charles's data by race*state*month*year			*
* c.  do Doug's impute method (Use later years to predict early years)	*
* d.  do Hilary's impute method (Aggregate death data to yearly level)	*
* Created by Charles Stoecker 2/07					*
*************************************************************************

* take three, alternate county sorting;

#delimit;
clear;
set mem 7000m;
set maxvar 15000;
set matsize 11000;
set more off;
capture log close;
log using makenat5967.log, replace;
pause off;

local path = "/3310/research/foodstamps/vitals_natality/data_vitals/natality5967/";


local newdata=0;	* set newdata to 1 to re-read the raw data;
local checkdata=0;	* set checkdata to 1 to re-check the data;
local reimpute=0;	* set reimpute to 1 to re-run the regressions;

tempfile tf tfmort;

/* Read in Doug's Data: Births by county*race*year */

if `newdata'==1 {;
  save cry59births, emptyok replace;

  foreach year of numlist 59(1)67 {;

    clear;
    insheet using "`path'/dougdata/19`year'_Douglas Almond.csv", clear comma;

    * The data has lots of redundant cells, city cells are not labeled, it looks like
      each county has the county totals (All Races, White, Nonwhite);
    gen id = _n;
    * Delete state totals;
    drop if cntyname=="Total"; 

    destring stfips, replace;

    * We never want more than the first three entries of any county;
    sort stfips countyfips id;
    by stfips countyfips: keep if _n<=3;

    * the nbirths from this file are county totals;
    rename nbirths nbirthsc;

    keep year stabb cntyname cityname race stfips countyfips nbirthsc id;

    replace nbirthsc = "0" if nbirthsc=="-";
    destring nbirthsc, replace;

    replace race = "1" if race=="W";
    replace race = "2" if race=="N";
    replace race = "." if race=="-";
    replace race = "0" if race=="Al";
    replace race = "0" if race=="All";
    replace race = "0" if race=="Alls";
    replace race = "1" if race=="White";
    replace race = "2" if race=="Nonwhite";
    destring race, replace;

    * In many cases different counties have been incorrectly labeled with the same countyfips code;
    * Find them here, and fix them in the raw data;
    bysort year stfips countyfips: gen num = _n;
    list if cntyname!=cntyname[_n-1] & num!=1;

    * Another way to find errors in the original data is to look for counties with 2 entries;
    bysort year stfips countyfips: gen numc = _N;
    list if numc==2;

    * Track the second time race==0 appears and drop all entries in the county after that;
    sort stfips countyfips id;
    by stfips countyfips: gen id2 = _n;

    * flag the second occurence of All;
    gen flag = id2 if race==0;
    replace flag = . if flag==1;
    by stfips countyfips: egen minflag = min(flag);
    drop if id2>=minflag;

    * Find counties where the white race is not in the second slot, another indication of error;
    list year stfips countyfips if id2!=2 & race==1;
    list year stfips countyfips if id2!=3 & race==2;

    keep year cntyname race stfips countyfips nbirthsc;

    * 1962 and 1964 have totals for New York City;
    drop if cntyname=="New York City" & stfips==. & (year==1962|year==1964);

    * in 1961 the NYC totals are identified differently;
    drop if cntyname=="New York City" & stfips==36 & countyfips==. & year==1961;

    * Still a problem with Newton, TX.  Don't know what to do with race=="-";

    qui do /3310/research/foodstamps/census/dofiles/makedata/countyfix.do;
    collapse (sum) nbirthsc, by(stfips countyfips race year);

    * generate state*race*year totals in county level data;
    bysort stfips race: egen nbirthsctot = sum(nbirthsc);

    sum;
    append using cry59births;
    save cry59births, replace;
  };

  * Drop Yellowstone;
  drop if countyfips==-99;

  * expand the yearly data to months to make the merge with month data more transparent;
  expand 12;
  bysort year stfips countyfips race: gen month = _n;
  sort year stfips race month;

  save cry59births, replace;

/* Read in Charles's Data */

  clear;
  save srm59births, emptyok replace;

  foreach year of numlist 59(1)67 {;

    clear;
    insheet using `path'/charlesdata/staterace19`year'.csv;

    gen year = 1900+`year';

    replace race = "1" if race=="white";
    replace race = "2" if race=="other";
    destring race, replace;

    * Birth counts by month;
    for num 1/12: rename monthX nbirthsmX;

    egen nbirthsmtot = rsum(nbirthsm1-nbirthsm12);

    * Reshape data so that each cell is state*month*year*race;
    keep year stfips race nbirthsm*;
    egen state_race = group(stfips race);
    reshape long nbirthsm, i(state_race) j(month);
    drop state_race;

    * Make a race "all" category;
    sort stfips month;
    save `tf', replace;
    collapse (sum) nbirthsm (mean) year, by(stfips month);
    gen race = 0;
    bysort stfips: egen nbirthsmtot = sum(nbirthsm);

    append using `tf';

    append using srm59births;
    save srm59births, replace;

  };

  sort year stfips race month;
  save srm59births, replace;

  * merge Charles's and Doug's data together;
  merge year stfips race month using cry59births;
  tab year stfips if _merge!=3 & nbirthsm>0 & stfips!=2;
  keep if _merge==3;
  drop _merge;

  compress;
  sort year stfips countyfips month race;
  save combined59births, replace;

}; /* brace ends newdata==1 section */

/* Check the data */
if `checkdata'==1 {;

  use combined59births, clear;
  * make sure the state*year totals match in the two datasets;
  for num 1959/1967: tab stfips if nbirthsctot!=nbirthsmtot & stfips!=2 & race==0 & year==X;

  /* Check data from Socheat here */

  gen flag = 1 if nbirthsctot!=nbirthsmtot;
  keep if race==0 & flag==1;
  collapse (mean) nbirthsctot nbirthsmtot, by(year stfips);
  list year stfips *tot if stfips!=2, clean noobs;

  use combined59births, clear;

  * Find the counties where the "all" race doesn't equal the total of the races, among counties that record subrace counts;
  * There are hundreds of these in the original data from Doug;
  bysort year stfips countyfips month: egen racetotc = sum(nbirthsc*((race==1)|(race==2)));
  list if racetotc!=nbirthsc & race==0 & racetotc!=0;

  * Figure out what percent of counties in each state-year report race breakouts;
  keep if month==1;
  bysort year stfips countyfips: egen reportrace = max(race==1);
  keep if race==0;
  collapse (mean) reportrace, by(year stfips);
  reshape wide reportrace, i(stfips) j(year);
  list, clean noobs;

}; /* brace ends checkdata==1 section */

/* Doug's Method */

if `reimpute'==1 {;

  clear;

  use /3310/research/foodstamps/vitals_mortality/data_mortality_detailed/mortality;
  append using /3310/research/foodstamps/vitals_mortality/data_mortality_detailed/mortality59deaths;

  * only use neonatal deaths to predict births;
  keep if neonatal==1;

  keep stfips countyfips year white month nbirths bcod1;

  gen race = 1 if white==1;
  replace race = 2 if white==0;
  drop white;
  save `tfmort';
  collapse (sum) bcod1 nbirths, by(year stfips countyfips month);
  gen race = 0;
  append using `tfmort';
  replace nbirths = . if year <= 1967;

  * aggregate month counts for 1968+ data to get nbirthsc variable;
  bysort year stfips countyfips race:  egen nbirthsc68 = sum(nbirths);

  * aggregate county counts for 1968+ data to get nbirthsm variable;
  bysort year stfips month race: egen nbirthsm68 = sum(nbirths);

  sort year stfips countyfips month race;
  merge year stfips countyfips month race using combined59births;
  *CS* This section has been hacked up to use only totals imputed for all races;
  keep if race==0;
  * _merge==2 are county*month*race cells with births but no deaths;
  tab _merge if month==1 & year<=1967;
  list if _merge==1 & month==1 & year<=1967;pause;
  * Menominee Wisconsin doesn't appear in birth data in 1960 and 1961;
  drop if _merge==1 & year<=1967 & stfips==55;
  * Hawaii doesn't appear in state data in 1959;
  drop if _merge==1 & year<=1967 & stfips==15;
  tab _merge if month==1 & year<=1967;
  drop _merge;
  replace bcod1 = 0 if bcod1==.;

  * make 1968+ data look like 1967- data;
  replace nbirthsc = nbirthsc68 if year>=1968;
  replace nbirthsm = nbirthsm68 if year>=1968;
  drop nbirthsc68 nbirthsm68;

  * merge in population in 1960;
  sort stfips countyfips;
  merge stfips countyfips using /3310/research/foodstamps/census/data_countybook/fscbdata_short;
  tab _merge;pause;
  keep if _merge==3;
  drop _merge;

  * create race*county*quarter intercepts;
  gen quarter = 1 if month<=3;
  replace quarter = 2 if month>=4 & month<=6;
  replace quarter = 3 if month>=7 & month<=9;
  replace quarter = 4 if month>=10 & month<=12;
  compress;

  *CS*  Stata's max matsize (number of variables allowed in a regression) is 11k.
  * that's just short of the 12k we'd need to run a regression with 3000 counties
  * times 4 quarters.  So I'm going to drop counties that never have more than 25
  * nbirths in the later period from the regressions;
  bysort stfips countyfips race:  egen maxnbirths = max(nbirths);
  sum;
  sum if maxnbirths < 25;
  drop if maxnbirths < 25;  

  egen scrq_id = group(stfips countyfips race quarter);

  *CS* I've tried running this with the "xi i.scrq_id" command with
  * amounts of memory up to 12 gigs allocated, but no dice;
  sum scrq_id;
  local numgroups = r(max);
  local i = 1;
  while (`i' <= `numgroups') {;
    gen byte scrq_fe`i' = scrq_id == `i';
    local i = `i' + 1;
  };

  compress;
  sum;

  keep year stfips countyfips month race nbirths nbirthsc nbirthsm bcod1 pop60 scrq*;
  compress;
  sum;

  reg nbirths nbirthsc nbirthsm bcod1 scrq_fe* if year>=1968 [aw=pop60];
  * using 68-77 to predict;
  reg nbirths nbirthsc nbirthsm bcod1 if year>=1968 [aw=pop60];
  predict dougbirths68;
  replace dougbirths68 = max(round(dougbirths68,1),0);

  * using 70-77 to predict;
  reg nbirths nbirthsc nbirthsm bcod1 scrq_fe* if year>=1970 [aw=pop60];
  predict dougbirths70;
  replace dougbirths70 = max(round(dougbirths70,1),0);

  * using 72-77 to predict;
  reg nbirths nbirthsc nbirthsm bcod1 scrq_fe* if year>=1972 [aw=pop60];
  predict dougbirths72;
  replace dougbirths72 = max(round(dougbirths72,1),0);

  drop scrq_fe*;

  label var nbirths "Actual births";
  label var dougbirths68 "Births predicted with Doug's method using 1968+";
  label var dougbirths70 "Births predicted with Doug's method using 1970+";
  label var dougbirths72 "Births predicted with Doug's method using 1972+";

  local year = 68;
  while `year' <=72 {;

    twoway (scatter dougbirths`year' nbirths) (line nbirths nbirths) if year==1968,
      title("Predicting nbirths 1968")
      subtitle("all county sizes");
    graph save doug`year'qall, replace;
    graph export doug`year'qall.ps, replace;

    twoway (scatter dougbirths`year' nbirths) (line nbirths nbirths) if year==1968 & nbirths<=12,
      title("Predicting nbirths 1968")
      subtitle("1st quartile county by number of births");
    graph save doug`year'q1, replace;
    graph export doug`year'q1.ps, replace;

    twoway (scatter dougbirths`year' nbirths) (line nbirths nbirths) if year==1968 & nbirths>12 & nbirths<=28,
      title("Predicting nbirths 1968") 
      subtitle("2nd quartile county by number of births");
    graph save doug`year'q2, replace;
    graph export doug`year'q2.ps, replace;

    twoway (scatter dougbirths`year' nbirths) (line nbirths nbirths) if year==1968 & nbirths>28 & nbirths<=66,
      title("Predicting nbirths 1968") 
      subtitle("3rd quartile county by number of births");
    graph save doug`year'q3, replace;
    graph export doug`year'q3.ps, replace;

    twoway (scatter dougbirths`year' nbirths) (line nbirths nbirths) if year==1968 & nbirths>66,
      title("Predicting nbirths 1968") 
      subtitle("4th quartile county by number of births");
    graph save doug`year'q4, replace;
    graph export doug`year'q4.ps, replace;

    local year = `year'+2;
  };

  sort year stfips countyfips month race;
  save dougtemp, replace;
};  /* brace ends reimpute section */

  use dougtemp, clear;
  replace nbirths = dougbirths68 if year<=1967;
  keep month year stfips countyfips nbirths race;
  keep if year<=1967;
  sort year stfips countyfips month race;
  compress;
  save dougbirths, replace;

/* We can use the yearly birthdata in combination with Doug's method to get a better count */

  use cry59births, clear;
  rename nbirthsc nbirthscounty;

  sort year stfips countyfips month race;
  merge year stfips countyfips month race using dougtemp;

  keep if race==0;
  keep if stfips!=2;

  tab _merge if year<=1967;

  replace nbirths = dougbirths68 if year<=1967;

  * total doug data across months (county*year*race);
  bysort year stfips countyfips race: egen dougctot = sum(nbirths);
  gen dougpct = nbirths/dougctot;
  sum nbirths dougctot if dougpct == .;
  replace dougpct = 0 if dougpct == .;

  * Doug's imputation method sets some counties to have negative or zero births for the whole year;
  * I'll use births in 1968 in these cases;
  bysort stfips countyfips race month: egen births68 = max(nbirths*(year==1968));
  bysort stfips countyfips race: egen births68tot = sum(nbirths*(year==1968));

  replace dougpct = births68/births68tot if dougctot==0;

  gen dougbirths_rescaled = dougpct*nbirthscounty;

  replace nbirths = dougbirths_rescaled if year<=1967;

  keep month year stfips countyfips nbirths race;
  keep if year<=1967;
  replace nbirths = max(round(nbirths,1),0);

  sort year stfips countyfips month race;
  compress;
  save dougbirths_rescaled, replace;

/* Another imputation option that uses Doug's rescaled method, but uses imputed values even when we know true births */

  use cry59births, clear;
  rename nbirthsc nbirthscounty;

  sort year stfips countyfips month race;
  merge year stfips countyfips month race using dougtemp;

  bysort year stfips countyfips race: egen nbirthscountytemp = sum(nbirths);
  replace nbirthscounty = nbirthscountytemp if year >= 1968;

  keep if race==0;
  keep if stfips!=2;

  tab _merge if year<=1967;

  replace nbirths = dougbirths68;

  * total doug data across months (county*year*race);
  bysort year stfips countyfips race: egen dougctot = sum(nbirths);
  gen dougpct = nbirths/dougctot;
  sum nbirths dougctot if dougpct == .;
  replace dougpct = 0 if dougpct == .;

  * Doug's imputation method sets some counties to have negative or zero births for the whole year;
  * I'll use births in 1968 in these cases;
  bysort stfips countyfips race month: egen births68 = max(nbirths*(year==1968));
  bysort stfips countyfips race: egen births68tot = sum(nbirths*(year==1968));

  replace dougpct = births68/births68tot if dougctot==0;
  replace dougpct = 0 if dougpct == .;

  gen dougbirths_rescaled = dougpct*nbirthscounty;pause;

  replace nbirths = dougbirths_rescaled;
  replace nbirths = max(round(nbirths,1),0);

  keep month year stfips countyfips nbirths race;
  sort year stfips countyfips month race;
  compress;
  save dougbirths_rescaled_allimputed, replace;  

/* Compare the methods */

  clear;
  use dougbirths_rescaled_allimputed;
  rename nbirths nbirthsdra;
  append using dougbirths_rescaled;
  rename nbirths nbirthsdr;
  append using dougbirths;
  rename nbirths nbirthsd;

  collapse (mean) nbirths*, by(year);
  list, clean noobs;

log close;
