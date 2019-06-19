*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
* Appendix-Table-1.do								*
*************************************************************************

#delimit;
drop _all;
set mem 1000m;
set more off;
capture log close;

tempfile tf tfinal;

local vlist = "bweight secondkid gest mom_ed legit attend";

/* Aggregate the source files */

  save `tf', emptyok;

  forvalues year= 1968(1)1977 {;

* raw natality files available publically;

    use nattest`year'.dta, clear;
    capture gen mom_ed=.;
    rename res_state stfips;
    keep year mom_race stfips recordweight `vlist';

    * Replace each variable with a flag for existence;
    foreach var in `vlist' {;
      gen `var'2 = `var'!=.;
      drop `var';
      rename `var'2 `var';
    };

    append using `tf';
    save `tf', replace;

  };

  * Keep only whites and blacks;
  keep if mom_race==1|mom_race==2;

  save `tf', replace;

/* Collapse to generate group averages */

  * generate whole US count by leaving out stfips here;
  collapse (mean) `vlist' [aweight=recordweight], by(mom_race year);

  gen stfips=0;
  sort stfips year;
  save `tfinal', replace;

  use `tf', clear;

  collapse (mean) `vlist' [aweight=recordweight], by(mom_race stfips year);

  sort stfips year;
  append using `tfinal';

/*
*state fips labels;
label define statefiplbl 0 "All U.S.";
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
label define statefiplbl 61 "Maine-New Hampshire-Vermont", add;
label define statefiplbl 62 "Massachusetts-Rhode Island", add;
label define statefiplbl 63 "Minnesota-Iowa-Missouri-Kansas-Nebraska-S.Dakota-N.Dakota", add;
label define statefiplbl 64 "Maryland-Delaware", add;
label define statefiplbl 65 "Montana-Idaho-Wyoming", add;
label define statefiplbl 66 "Utah-Nevada", add;
label define statefiplbl 67 "Arizona-New Mexico", add;
label define statefiplbl 68 "Alaska-Hawaii", add;
label define statefiplbl 94 "Indian Territory", add;
label define statefiplbl 97 "Military/Mil. Reservation", add;
label define statefiplbl 99 "State not identified", add;
label values stfips statefiplbl;
*/

sort mom_race stfips year;


outsheet using checkvars.out, replace;


log close;

