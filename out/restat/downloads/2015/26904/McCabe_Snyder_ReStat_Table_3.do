log using McCabe_Snyder_ReStat_Table_3, replace

**********************************************************************
*
* Program McCabe_Snyder_ReStat_Table_3.DO
* 
* Runs regressions behind Table 3 involving alternative specifications
* for aggregage digitization results. 
*
* McCabe & Snyder August 2013
*
**********************************************************************

************************************;
*** Set initial Stata parameters ***;
************************************;

version 12
set memory 900m
set matsize 4000 
set more 1
#delimit ;


*****************;
*** Load data ***;
*****************;

use McCabe_Snyder_ReStat_combined;

gen cit = cusa + ceng + ceur + coth + cmis;
summ;
sort journal pyear cyear;
by journal pyear:  gen cit_lag = cit[_n-1];


***************************************************************;
*** Create cyear variables and journal volume fixed effects ***;
***************************************************************;

forvalues num = 1956/2005 {;
   quietly gen byte py`num' = (pyear == `num');
   };

forvalues x = 80/99 {;
   quietly gen byte c`x' = (cyear == 1900 + `x');
   };

forvalues x = 0/4 {;
   quietly gen byte c0`x' = (cyear == 2000 + `x');
   };

* create journal volume fixed effect groups;
sort journal pyear;
egen volume = group(journal pyear);


**********************************************************************;
*** Generate other variables                                       ***;
**********************************************************************;

* Suffix 1 refers to partial access;
gen digit1 = ((own1 + elsevier1 + jstor1 + ingaoc1 +  blackwell1 + ebsco1 + proquest1 + digz1) >= 1);

* Suffix 2 refers to full access;
gen digit2 = ((own2 + elsevier2 + jstor2 + ingaoc2 +  blackwell2 + ebsco2 + proquest2 + digz2) >= 1);
replace digit1 = 0 if digit2 == 1;

gen c95_99 = (cyear >= 1995 & cyear <= 1999);
gen c00_05 = (cyear >= 2000 & cyear <= 2005);
gen d1c95 = digit1 * c95_99;
gen d1c00 = digit1 * c00_05;
gen d2c95 = digit2 * c95_99;
gen d2c00 = digit2 * c00_05;
drop c95_99 c00_05;

gen age = cyear - pyear;
gen age2 = age^2;
gen age3 = age^3;
gen age4 = age^4;

save temp_data, replace;


**********************************************************************;
*** 1956-1965                                                      ***;
**********************************************************************;

gen plower = 1956;
gen pupper = 1965;

keep if pyear >= plower & pyear <= pupper;

* Create fixed effects for publication x citation year interactions;
* Drop the 2005 cyear to avoid multicolinearity with the constant;
* Don't create variables with pyear after cyear;
* Do create variables with pyear = cyear since keeping age0 = 1 observations;

forvalues y = 56/99 {;
   forvalues x = 80/99 {;
      quietly gen ip`y'c`x' = py19`y' * c`x' if 
         (`x' >= `y') 
       & (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 56/99 {;
   forvalues x = 0/4 {;
      quietly gen ip`y'c0`x' = py19`y' * c0`x' if
         (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 0/5 {;
   forvalues x = 0/4 {;
      quietly gen ip0`y'c0`x' = py200`y' * c0`x' if
         (`x' >= `y')
       & (2000 + `y' >= plower) 
       & (2000 + `y' <= pupper);
   };
};

foreach var of varlist ip* {;
   capture assert !missing(`var');
   if _rc {;
      drop `var';
   };
};


egen title = group(journal);
rename journal smournal;
quietly tabulate title, generate(journal);
drop title;

foreach var of varlist journal* {;
   quietly gen ia1`var' = age * `var';
   quietly gen ia2`var' = age2 * `var';
   quietly gen ia3`var' = age3 * `var';
   quietly gen ia4`var' = age4 * `var';
};

rename smournal journal;

* Avoid multicolinearity by dropping first journal's age profile; 
drop ia1journal1 ia2journal1 ia3journal1 ia4journal1; 

* Column 1: No fixed effects or journal age profile;
poisson cit  ip* d1c* d2c*, irr cluster(journal);  

* Column 2: Journal fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(journal) irr fe cluster(journal); 

* Column 3: Volume fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 4: Volume fixed effects and age profile;
xtpqml cit ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 5: Evans replication, with journal volume fixed effects, citation lags;

xtpqml cit cit_lag d1c* d2c*, i(volume) irr fe cluster(journal);

* Column 6: Combine citation lags with journal volumen fixed effects,
* time effects, and age profiles;
  
xtpqml cit cit_lag ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal);


**********************************************************************;
*** 1966-1975                                                      ***;
**********************************************************************;

clear;
use temp_data;

gen plower = 1966;
gen pupper = 1975;

keep if pyear >= plower & pyear <= pupper;

* Create fixed effects for publication x citation year interactions;
* Drop the 2005 cyear to avoid multicolinearity with the constant;
* Don't create variables with pyear after cyear;
* Do create variables with pyear = cyear since keeping age0 = 1 observations;

forvalues y = 56/99 {;
   forvalues x = 80/99 {;
      quietly gen ip`y'c`x' = py19`y' * c`x' if 
         (`x' >= `y') 
       & (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 56/99 {;
   forvalues x = 0/4 {;
      quietly gen ip`y'c0`x' = py19`y' * c0`x' if
         (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 0/5 {;
   forvalues x = 0/4 {;
      quietly gen ip0`y'c0`x' = py200`y' * c0`x' if
         (`x' >= `y')
       & (2000 + `y' >= plower) 
       & (2000 + `y' <= pupper);
   };
};

foreach var of varlist ip* {;
   capture assert !missing(`var');
   if _rc {;
      drop `var';
   };
};


egen title = group(journal);
rename journal smournal;
quietly tabulate title, generate(journal);
drop title;

foreach var of varlist journal* {;
   quietly gen ia1`var' = age * `var';
   quietly gen ia2`var' = age2 * `var';
   quietly gen ia3`var' = age3 * `var';
   quietly gen ia4`var' = age4 * `var';
};

rename smournal journal;

* Avoid multicolinearity by dropping first journal's age profile; 
drop ia1journal1 ia2journal1 ia3journal1 ia4journal1; 

* Column 1: No fixed effects or journal age profile;
poisson cit  ip* d1c* d2c*, irr cluster(journal);  

* Column 2: Journal fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(journal) irr fe cluster(journal); 

* Column 3: Volume fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 4: Volume fixed effects and age profile;
xtpqml cit ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 5: Evans replication, with journal volume fixed effects, citation lags;

xtpqml cit cit_lag d1c* d2c*, i(volume) irr fe cluster(journal);

* Column 6: Combine citation lags with journal volumen fixed effects,
* time effects, and age profiles;
  
xtpqml cit cit_lag ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal);


**********************************************************************;
*** 1976-1985                                                      ***;
**********************************************************************;

clear;
use temp_data;

gen plower = 1976;
gen pupper = 1985;

keep if pyear >= plower & pyear <= pupper;

* Create fixed effects for publication x citation year interactions;
* Drop the 2005 cyear to avoid multicolinearity with the constant;
* Don't create variables with pyear after cyear;
* Do create variables with pyear = cyear since keeping age0 = 1 observations;

forvalues y = 56/99 {;
   forvalues x = 80/99 {;
      quietly gen ip`y'c`x' = py19`y' * c`x' if 
         (`x' >= `y') 
       & (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 56/99 {;
   forvalues x = 0/4 {;
      quietly gen ip`y'c0`x' = py19`y' * c0`x' if
         (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 0/5 {;
   forvalues x = 0/4 {;
      quietly gen ip0`y'c0`x' = py200`y' * c0`x' if
         (`x' >= `y')
       & (2000 + `y' >= plower) 
       & (2000 + `y' <= pupper);
   };
};

foreach var of varlist ip* {;
   capture assert !missing(`var');
   if _rc {;
      drop `var';
   };
};


egen title = group(journal);
rename journal smournal;
quietly tabulate title, generate(journal);
drop title;

foreach var of varlist journal* {;
   quietly gen ia1`var' = age * `var';
   quietly gen ia2`var' = age2 * `var';
   quietly gen ia3`var' = age3 * `var';
   quietly gen ia4`var' = age4 * `var';
};

rename smournal journal;

* Avoid multicolinearity by dropping first journal's age profile; 
drop ia1journal1 ia2journal1 ia3journal1 ia4journal1; 

* Column 1: No fixed effects or journal age profile;
poisson cit  ip* d1c* d2c*, irr cluster(journal);  

* Column 2: Journal fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(journal) irr fe cluster(journal); 

* Column 3: Volume fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 4: Volume fixed effects and age profile;
xtpqml cit ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 5: Evans replication, with journal volume fixed effects, citation lags;

xtpqml cit cit_lag d1c* d2c*, i(volume) irr fe cluster(journal);

* Column 6: Combine citation lags with journal volumen fixed effects,
* time effects, and age profiles;
  
xtpqml cit cit_lag ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal);


**********************************************************************;
*** 1986-1995                                                      ***;
**********************************************************************;

clear;
use temp_data;

gen plower = 1986;
gen pupper = 1995;

keep if pyear >= plower & pyear <= pupper;

* Create fixed effects for publication x citation year interactions;
* Drop the 2005 cyear to avoid multicolinearity with the constant;
* Don't create variables with pyear after cyear;
* Do create variables with pyear = cyear since keeping age0 = 1 observations;

forvalues y = 56/99 {;
   forvalues x = 80/99 {;
      quietly gen ip`y'c`x' = py19`y' * c`x' if 
         (`x' >= `y') 
       & (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 56/99 {;
   forvalues x = 0/4 {;
      quietly gen ip`y'c0`x' = py19`y' * c0`x' if
         (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 0/5 {;
   forvalues x = 0/4 {;
      quietly gen ip0`y'c0`x' = py200`y' * c0`x' if
         (`x' >= `y')
       & (2000 + `y' >= plower) 
       & (2000 + `y' <= pupper);
   };
};

foreach var of varlist ip* {;
   capture assert !missing(`var');
   if _rc {;
      drop `var';
   };
};


egen title = group(journal);
rename journal smournal;
quietly tabulate title, generate(journal);
drop title;

foreach var of varlist journal* {;
   quietly gen ia1`var' = age * `var';
   quietly gen ia2`var' = age2 * `var';
   quietly gen ia3`var' = age3 * `var';
   quietly gen ia4`var' = age4 * `var';
};

rename smournal journal;

* Avoid multicolinearity by dropping first journal's age profile; 
drop ia1journal1 ia2journal1 ia3journal1 ia4journal1; 

* Column 1: No fixed effects or journal age profile;
poisson cit  ip* d1c* d2c*, irr cluster(journal);  

* Column 2: Journal fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(journal) irr fe cluster(journal); 

* Column 3: Volume fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 4: Volume fixed effects and age profile;
xtpqml cit ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 5: Evans replication, with journal volume fixed effects, citation lags;

xtpqml cit cit_lag d1c* d2c*, i(volume) irr fe cluster(journal);

* Column 6: Combine citation lags with journal volumen fixed effects,
* time effects, and age profiles;
  
xtpqml cit cit_lag ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal);


**********************************************************************;
*** 1996-2005                                                      ***;
**********************************************************************;

clear;
use temp_data;

gen plower = 1996;
gen pupper = 2005;

keep if pyear >= plower & pyear <= pupper;

* Create fixed effects for publication x citation year interactions;
* Drop the 2005 cyear to avoid multicolinearity with the constant;
* Don't create variables with pyear after cyear;
* Do create variables with pyear = cyear since keeping age0 = 1 observations;

forvalues y = 56/99 {;
   forvalues x = 80/99 {;
      quietly gen ip`y'c`x' = py19`y' * c`x' if 
         (`x' >= `y') 
       & (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 56/99 {;
   forvalues x = 0/4 {;
      quietly gen ip`y'c0`x' = py19`y' * c0`x' if
         (1900 + `y' >= plower) 
       & (1900 + `y' <= pupper);
   };
};

forvalues y = 0/5 {;
   forvalues x = 0/4 {;
      quietly gen ip0`y'c0`x' = py200`y' * c0`x' if
         (`x' >= `y')
       & (2000 + `y' >= plower) 
       & (2000 + `y' <= pupper);
   };
};

foreach var of varlist ip* {;
   capture assert !missing(`var');
   if _rc {;
      drop `var';
   };
};


egen title = group(journal);
rename journal smournal;
quietly tabulate title, generate(journal);
drop title;

foreach var of varlist journal* {;
   quietly gen ia1`var' = age * `var';
   quietly gen ia2`var' = age2 * `var';
   quietly gen ia3`var' = age3 * `var';
   quietly gen ia4`var' = age4 * `var';
};

rename smournal journal;

* Avoid multicolinearity by dropping first journal's age profile; 
drop ia1journal1 ia2journal1 ia3journal1 ia4journal1; 

* Column 1: No fixed effects or journal age profile;
poisson cit  ip* d1c* d2c*, irr cluster(journal);  

* Column 2: Journal fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(journal) irr fe cluster(journal); 

* Column 3: Volume fixed effects, no age profile;
xtpqml cit ip* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 4: Volume fixed effects and age profile;
xtpqml cit ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal); 

* Column 5: Evans replication, with journal volume fixed effects, citation lags;

xtpqml cit cit_lag d1c* d2c*, i(volume) irr fe cluster(journal);

* Column 6: Combine citation lags with journal volumen fixed effects,
* time effects, and age profiles;
  
xtpqml cit cit_lag ip* ia1j* ia2j* d1c* d2c*, i(volume) irr fe cluster(journal);

erase temp_data.dta;
