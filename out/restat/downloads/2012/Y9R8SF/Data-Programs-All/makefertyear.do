*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
*************************************************************************

*************************************************************************
* makefertyear.do							*
* makes fertility data to be used in fertility of "at risk" population	*
* analysis	       	     	     	       	      	    		*
* This fertility analysis is collapsed to yearly level to enable 	*
* analysis back to 1959							*
*************************************************************************

  #delimit;
  drop _all;
  set memory 100m;
  set more off;
  capture log close;

  tempfile tfbirths tfbirths1 tfbirths2 tfbirths3 tfpop tfpop1 tfpop2 tfpop3;
 

*******************;
* BIRTH DATA      *;
*******************;

*****;
* 1968+ data;
*****;

* created in makenat.do;

  use natality_main, clear;

  keep if mom_race==1|mom_race==2;
  gen race = 1 if mom_race==1;
  replace race = 2 if mom_race==2;

* collapse 1968-1977 births to annual counts since that is all we have in the 1959-1967 data;
* BY BLACK, WHITE counts;
  collapse (max) fs* (sum) nbirths, by(race stfips countyfips year);
  summ;
  save `tfbirths', replace;

  use natality_main, clear;

* Include "other races" since we will use total birth counts;
* from the print data on births.;
  keep if mom_race==1|mom_race==2|mom_race==9;

* collapse 1968-1977 births to annual counts since that is all we have in the 1959-1967 data;
* all RACES, INCLUDING NONBLACK NONWHITE WHEN AVAILABLE;
  collapse (max) fs* (sum) nbirths, by(stfips countyfips year);
  gen race=0;
  append using `tfbirths';

  sort race stfips countyfips year;
  table year race, c(sum nbirths) cellwidth(12) format(%11.0fc);
  save `tfbirths1', replace;

  summ;

********;
* 1959-67;
*********;

* created by makenat5967.do (raw data from print documents obtained by Doug Almond, data births by year*state*county*race);
  use cry59births;

* annual data; 
  keep if month==1;

  rename nbirthsc nbirths;

  keep year race stfips countyfips nbirths;
  summ;

  save `tfbirths2', replace;

* note total^=black+white because B W are only available for counties with sufficienctly large pop;
* but the total should be right;
  table year race, c(sum nbirths) cellwidth(12) format(%11.0fc);

  append using `tfbirths1';

  sort race stfips countyfips year;
  summ;

* check magnitudes here;
  format nbirths %10.0fc;
  table year race, c(sum nbirths) cellwidth(12) format(%11.0fc);

  save `tfbirths3', replace;


***************************;
* POPULATION DATA          ;
***************************;

**********;
* 1968-1977 population;
**********;

  use pop6879long, clear;
  drop if year>1977;
  drop if stfips==2;

  /* variables in the pop file
  racesex1=White male
  2=White female
  3=Black male
  4=Black female
  5=Other male
  6=Other female
  */

* Keep other female to create all race population figure;
* population is women 15-44 (all races);

  drop if racesex==1|racesex==3|racesex==5;

  gen race = 1 if racesex==2 | racesex==1;
  replace race = 2 if racesex==3 | racesex==4;
  replace race = 9 if racesex==5 | racesex==6;
  drop racesex;

  *fix (some) VA counties;
  do countyfix.do;

************************;
* UPDATE TO INCLUDE ONLY WOMEN 15-44 WHEN WE GET THAT DATA FOR 1960;
************************;
  egen pop1544=rsum(pop1519_-pop3544_);

*  egen pop = rsum(pop0104_-pop85p_);
  keep pop1544 race stfips countyfips year;
  save `tfpop', replace;

* collapse by RACE; 
  collapse (sum) pop1544, by(race stfips countyfips year);
  save `tfpop1', replace;


* collapse for ALL RACES (including other);
  use `tfpop', clear;
  collapse (sum) pop1544, by(stfips countyfips year);
  gen race=0;

  append using `tfpop1';

format pop1544 %10.0fc;
table year race, c(sum pop1544) cellwidth(12) format(%11.0fc);

  drop if race==9;
  save `tfpop2', replace;


*****************;
  * 1960 population;
*****************;

* 1960 POPULATION BY RACE/SEX, FROM 15-44 WOMEN;
* Source: http://www.nhgis.org/;

  use pop1960;

  /* variables in the pop file racesex
1 White male
2 White female
3 Black male
4 Black female
"black" includes other races so they sum to total population
  */

* Keep other female to create all race population figure;
* population is women 15-44 (all races);

  drop if racesex==1|racesex==3;

  gen race = 1 if racesex==2 | racesex==1;
  replace race = 2 if racesex==3 | racesex==4;
  replace race = 9 if racesex==5 | racesex==6;
  drop racesex;

  egen pop1544=rsum(pop1519_-pop3544_);

  keep pop1544 race stfips countyfips year;
  save `tfpop', replace;

* collapse by RACE; 
  collapse (sum) pop1544, by(race stfips countyfips year);
  save `tfpop1', replace;


* collapse for ALL RACES (including other);
  use `tfpop', clear;
  collapse (sum) pop1544, by(stfips countyfips year);
  gen race=0;

  append using `tfpop1';

format pop1544 %10.0fc;
table year race, c(sum pop1544) cellwidth(12) format(%11.0fc);

  drop if race==9;

  save `tfpop3', replace;

  keep stfips countyfips race pop1544;

format pop1544 %10.0fc;
table race, c(sum pop1544) cellwidth(12) format(%11.0fc);

  expand 9;
  bysort stfips countyfips race: gen year = 1958 + _n;
  replace pop1544 = . if year != 1960;
  append using `tfpop2';

  * impute;

  bysort stfips countyfips race: ipolate pop1544 year, gen(pop1544hat) epolate;
  drop pop1544;
  rename pop1544hat pop1544;

table year race, c(sum pop1544) cellwidth(12) format(%11.0fc);

******************;
* Merge POP AND BIRTHS;
******************;

  sort race stfips countyfips year;
  merge race stfips countyfips year using `tfbirths3';
  tab _merge;

  bysort stfips countyfips: egen meanfsy = mean(fs_year);
  bysort stfips countyfips: egen meanfsm = mean(fs_month);
  replace fs_year = meanfsy if fs_year==.;
  replace fs_month = meanfsm if fs_month==.;
  replace nbirths = 0 if nbirths==.;

  drop if stfips==2;
  keep stfips countyfips pop1544 race year nbirths fs_month fs_year;

* get a sense if the magnitudes are correct;

table year race, c(sum nbirths) cellwidth(12) format(%11.0fc);
table year race, c(sum pop1544) cellwidth(12) format(%11.0fc);

  compress;
  sum;

  save fertilityyear, replace;

*****************;
* End of Dofile *;
*****************;

log close;

