log using McCabe_Snyder_ReStat_Table_7, replace

**********************************************************************
*
* Program McCabe_Snyder_ReStat_Table_7.DO
* 
* Runs regressions for quintile results in Table 7. 
*
* McCabe & Snyder August 2013
*
**********************************************************************

**********************************************************************
* 
* Note on computation of subscription elasticity. Take marginal effect,
* which is IRR - 1.  Then multiply by mean number of subscribers. 
* Relevant means are provided after each regression.
*
**********************************************************************

* Set initial Stata parameters
version 12
set more 1
set matsize 4000 
#delimit ;

use McCabe_Snyder_ReStat_combined;
drop if quintile_merge==1;
summ;

* Set threshold to screen out observations forcing us to estimate;
* OA variables with few degrees of freedom behind them;
gen threshold = 10;

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

 *******************************************************************;
*** Generate digitization variables                              ***;
********************************************************************;

* Generate channel count variables;
gen partial = own1 + elsevier1 + jstor1 + ingenta1 + gale1 + oclc1 +  blackwell1 + ebsco1 + proquest1 + digz1;
gen full    = own2 + elsevier2 + jstor2 + ingenta2 + gale2 + oclc2 +  blackwell2 + ebsco2 + proquest2 + digz2;
gen other_partial = own1 + ingenta1 + gale1 + oclc1 +  blackwell1 + ebsco1 + proquest1 + digz1;
gen other_full    = own2 + ingenta2 + gale2 + oclc2 +  blackwell2 + ebsco2 + proquest2 + digz2;

* Generate other variables;
gen op = (other_partial > 0) & (other_full == 0);
gen os = (other_partial == 0) & (other_full == 1);
gen oh = (other_partial > 0) & (other_full == 1);
gen om = other_full >= 2;

* JSTOR partial dummy;
gen jp  = jstor1 > 0;

* JSTOR subs variables;
gen jsfs = jss2 * (jstor1 == 0) * (jstor2 == 1) * (other_partial == 0) * (other_full == 0);
gen jsfp = jss2 * (jstor1 == 0) * (jstor2 == 1) * (other_partial > 0) * (other_full == 0);
gen jsfd = jss2 * (jstor1 == 0) * (jstor2 == 1) * (other_full >= 1);

* Elsevier dummies for partial access and full access to current content;
gen ep  = elsevier1 > 0;
gen ecf = (elsevier1 == 0) * (elsevier2 == 1) * (es2 == 0);

* Elsevier subs;
gen esf = es2 * (elsevier1 == 0) * (elsevier2 == 1);

* Dummies for screening;
gen jsfs_dum = jsfs > 0;
gen jsfp_dum = jsfp > 0;
gen jsfd_dum = jsfd > 0;
gen esf_dum = esf > 0;

* Interact with citation-year blocks;
gen c95_99 = (cyear >= 1995 & cyear <= 1999);
gen c00_05 = (cyear >= 2000 & cyear <= 2005);
foreach abbrev in op os oh om jp ep ecf {;
   quietly gen `abbrev'95 = `abbrev' * c95_99;
   quietly gen `abbrev'00 = `abbrev' * c00_05;
   };
drop c95_99 c00_05 op os oh om jp ep ecf;

* Generate remaining variables;
gen cit = cusa + ceng + ceur + coth + cmis;
gen age = cyear - pyear;
gen age2 = age^2;
gen age3 = age^3;
gen age4 = age^4;

save temp_quintile, replace;


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

 * avoid multicolinearity by dropping first journal's age profile;
 drop ia1journal1 ia2journal1 ia3journal1 ia4journal1;

* screen for small numbers within digitization categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* apply second screen to pick up newly created small categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* Run regression;
xtpqml cit_80   ip* ia1j* ia2j* 
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;

xtpqml cit_60_80   ip* ia1j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_40_60  ip* ia1j* 
            op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20_40   ip* ia1j*  
            op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20   ip* ia1j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);


**********************************************************************;
*** 1966-1975                                                      ***;
**********************************************************************;

clear;
use temp_quintile;
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

 * avoid multicolinearity by dropping first journal's age profile;
 drop ia1journal1 ia2journal1 ia3journal1 ia4journal1;

* screen for small numbers within digitization categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* apply second screen to pick up newly created small categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* run regression;
xtpqml cit_80   ip* ia1j* ia2j* 
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;

xtpqml cit_60_80   ip* ia1j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_40_60  ip* ia1j* ia2j*
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20_40   ip* ia1j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20   ip* ia1j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);


**********************************************************************;
*** 1976-1985                                                      ***;
**********************************************************************;
 
clear;
use temp_quintile;
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

* avoid multicolinearity by dropping first journal's age profile;
drop ia1journal1 ia2journal1 ia3journal1 ia4journal1;

* screen for small numbers within digitization categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* apply second screen to pick up newly created small categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* Run regression;
xtpqml cit_80   ip* ia1j* ia2j* 
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;

xtpqml cit_60_80   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_40_60  ip* ia1j* ia2j* 
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20_40   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);


**********************************************************************;
*** 1986-1995                                                      ***;
**********************************************************************;

clear;
use temp_quintile;
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

* avoid multicolinearity by dropping first journal's age profile;
drop ia1journal1 ia2journal1 ia3journal1 ia4journal1;


* screen for small numbers within digitization categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* apply second screen to pick up newly created small categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* Run regression;
xtpqml cit_80   ip* ia1j* ia2j* 
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;

xtpqml cit_60_80   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_40_60  ip* ia1j* ia2j* 
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20_40   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);


**********************************************************************;
*** 1996-2005                                                      ***;
**********************************************************************;
 
clear;
use temp_quintile;
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

* avoid multicolinearity by dropping first journal's age profile;
drop ia1journal1 ia2journal1 ia3journal1 ia4journal1;

* screen for small numbers within digitization categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* apply second screen to pick up newly created small categories;
foreach var in op95 op00 os95 os00 oh95 oh00 om95 om00 
               jp95 jp00  
               ep95 ep00 ecf95 ecf00
               jsfs_dum jsfp_dum jsfd_dum esf_dum {;
   quietly egen countvar = total(`var' > 0);
   drop if (countvar <= threshold) & (`var' > 0);
   drop countvar;
   };

* run regression;
xtpqml cit_80   ip* ia1j* ia2j* 
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;

xtpqml cit_60_80   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_40_60  ip* ia1j* ia2j* 
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20_40   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);

xtpqml cit_20   ip* ia1j* ia2j*  
           op95 op00 os95 os00 oh95 oh00 om95 om00 
           jp95 jp00  
           ep95 ep00 ecf95 ecf00
           jsfs jsfp jsfd esf, 
           i(volume) irr fe cluster(journal);
