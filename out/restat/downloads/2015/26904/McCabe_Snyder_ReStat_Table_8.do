log using McCabe_Snyder_ReStat_Table_8, replace

**********************************************************************
*
* Program McCabe_Snyder_ReStat_Table_8.DO
* 
* Runs regressions for long-tail analysis in Table 8. 
* Based on ECON_XTREG_VOLUME_TRENDS_LONGTAIL_05.DO. 
*
* McCabe & Snyder August 2013
*
**********************************************************************

**********************************************************************
* 
* Note on computation of subscription elasticity. Take marginal effect,
* which is IRR - 1.  Then multiply by mean number of subscribers and 
* divide by predicted mean y. Relevant means are provided after each 
* regression.
*
**********************************************************************

* Set initial Stata parameters
version 12
set more 1
set matsize 4000 
#delimit ;

use McCabe_Snyder_ReStat_combined;
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


********************************************************************;
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

* Aggregate digitization variables;
gen d1c = partial >= 1;
gen d2c = full >= 1;
replace d1c = 0 if d2c == 1;

* Partial access dummy = 1 if partial access through some channels and no full access;
gen dp = (partial > 0) & (full == 0);

* Hybrid access dummy = 1 if partial access through some channels and full access through exactly 1 channel;
gen dh = (partial > 0) & (full == 1);

* Sole access dummy = 1 if full access through exactly 1 channel and no partial access;
gen ds = (partial == 0) & (full == 1);

* Multiple access dummy = 1 if full access through 2+ channels (additional partial access possible);
gen dm = (full >= 2); 

* Generate JSTOR variables;
gen jp   = jstor1 > 0;
gen jfs  = (jstor1 == 0) & (jstor2 == 1) & (other_partial == 0) & (other_full == 0);
gen jfp  = (jstor1 == 0) & (jstor2 == 1) & (other_partial > 0) & (other_full == 0);
gen jfd  = (jstor1 == 0) & (jstor2 == 1) & (other_full >= 1);
gen jsfs = jss2 * (jstor1 == 0) * (jstor2 == 1) * (other_partial == 0) * (other_full == 0);
gen jsfp = jss2 * (jstor1 == 0) * (jstor2 == 1) * (other_partial > 0) * (other_full == 0);
gen jsfd = jss2 * (jstor1 == 0) * (jstor2 == 1) * (other_full >= 1);

* Elsevier dummies for partial access and full access to current content;
gen ep  = elsevier1 > 0;
gen ef  = (elsevier1 == 0) & (elsevier2 == 1);
gen ecf = (elsevier1 == 0) * (elsevier2 == 1) * (es2 == 0);
gen esf = es2 * (elsevier1 == 0) * (elsevier2 == 1);

* Dummies for screening;
gen jsfs_dum = jsfs > 0;
gen jsfp_dum = jsfp > 0;
gen jsfd_dum = jsfd > 0;
gen esf_dum = esf > 0;

* Interact with citation-year blocks;
gen c95_99 = (cyear >= 1995 & cyear <= 1999);
gen c00_05 = (cyear >= 2000 & cyear <= 2005);
foreach abbrev in d1c d2c dp dh ds dm op os oh om jp ep ecf jfs jfp jfd ef {;
   quietly gen `abbrev'95 = `abbrev' * c95_99;
   quietly gen `abbrev'00 = `abbrev' * c00_05;
   };
drop c95_99 c00_05 d1c d2c dp dh ds dm op os oh om jp ep ecf;

* Generate remaining variables;
gen age = cyear - pyear;
gen age2 = age^2;
gen age3 = age^3;
gen age4 = age^4;

gen fraction_null = count_null/obs_count;
replace fraction_null = 1 if fraction_80 == .;
gen ln_null = ln(fraction_null);
gen fraction_pos = 1 - fraction_null;
save lt_temp, replace;


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


* Build within-volume average covariates;
* Replaces fixed effects in Papke-Wooldridge (2008) method;

* When generate marginal effect, set other digitization variables at their means;
* Another approach would be to zero out all digitization variables, but more tedious;
* Another issue is whether to look at only subsets of data by cyear period or channel;
* Decide to project onto whole pyear block subsample;

sort volume;
foreach var of varlist ip* ia1j* ia2j* 
                        d1c* d2c* 
                        dp95 dp00 dh95 dh00 ds95 ds00 dm95 dm00
                        op95 op00 os95 os00 oh95 oh00 om95 om00 
                        jp95 jp00  
                        ep95 ep00 ecf95 ecf00
                        jfs95 jfs00 jfp95 jfp00 jfd95 jfd00 
                        ef95 ef00
                        jsfs jsfp jsfd esf {;
   by volume: egen m`var' = mean(`var');
};

save lt_temp_1, replace;



* Channel subscription specifications;

clear;
use lt_temp_1;

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

glm fraction_pos mip* mia1j* mia2j* 
                 mop95 mop00 mos95 mos00 moh95 moh00 mom95 mom00 
                 mjp95 mjp00  
                 mep95 mep00 mecf95 mecf00
                 mjsfs mjsfp mjsfd mesf
                 ip* ia1j* ia2j* 
                 op95 op00 os95 os00 oh95 oh00 om95 om00 
                 jp95 jp00  
                 ep95 ep00 ecf95 ecf00
                 jsfs jsfp jsfd esf,  
                 family(binomial) link(probit) cluster(journal);

mfx, varlist(jsfs jsfp jsfd esf);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;


**********************************************************************;
*** 1966-1975                                                      ***;
**********************************************************************;

clear;
use lt_temp;

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

* Build within-volume average covariates;
* Replaces fixed effects in Papke-Wooldridge (2008) method;

* When generate marginal effect, set other digitization variables at their means;
* Another approach would be to zero out all digitization variables, but more tedious;
* Another issue is whether to look at only subsets of data by cyear period or channel;
* Decide to project onto whole pyear block subsample;

sort volume;
foreach var of varlist ip* ia1j* ia2j* 
                        d1c* d2c* 
                        dp95 dp00 dh95 dh00 ds95 ds00 dm95 dm00
                        op95 op00 os95 os00 oh95 oh00 om95 om00 
                        jp95 jp00  
                        ep95 ep00 ecf95 ecf00
                        jfs95 jfs00 jfp95 jfp00 jfd95 jfd00 
                        ef95 ef00
                        jsfs jsfp jsfd esf {;
   by volume: egen m`var' = mean(`var');
};

save lt_temp_1, replace;



* Channel subscription specifications;

clear;
use lt_temp_1;

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

glm fraction_pos mip* mia1j* mia2j* 
                 mop95 mop00 mos95 mos00 moh95 moh00 mom95 mom00 
                 mjp95 mjp00  
                 mep95 mep00 mecf95 mecf00
                 mjsfs mjsfp mjsfd mesf
                 ip* ia1j* ia2j* 
                 op95 op00 os95 os00 oh95 oh00 om95 om00 
                 jp95 jp00  
                 ep95 ep00 ecf95 ecf00
                 jsfs jsfp jsfd esf,  
                 family(binomial) link(probit) cluster(journal);

mfx, varlist(jsfs jsfp jsfd esf);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;


**********************************************************************;
*** 1976-1985                                                      ***;
**********************************************************************;

clear;
use lt_temp;

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

* Build within-volume average covariates;
* Replaces fixed effects in Papke-Wooldridge (2008) method;

* When generate marginal effect, set other digitization variables at their means;
* Another approach would be to zero out all digitization variables, but more tedious;
* Another issue is whether to look at only subsets of data by cyear period or channel;
* Decide to project onto whole pyear block subsample;

sort volume;
foreach var of varlist ip* ia1j* ia2j* 
                        d1c* d2c* 
                        dp95 dp00 dh95 dh00 ds95 ds00 dm95 dm00
                        op95 op00 os95 os00 oh95 oh00 om95 om00 
                        jp95 jp00  
                        ep95 ep00 ecf95 ecf00
                        jfs95 jfs00 jfp95 jfp00 jfd95 jfd00 
                        ef95 ef00
                        jsfs jsfp jsfd esf {;
   by volume: egen m`var' = mean(`var');
};

save lt_temp_1, replace;

* Channel subscription specifications;

clear;
use lt_temp_1;

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

glm fraction_pos mip* mia1j* mia2j* 
                 mop95 mop00 mos95 mos00 moh95 moh00 mom95 mom00 
                 mjp95 mjp00  
                 mep95 mep00 mecf95 mecf00
                 mjsfs mjsfp mjsfd mesf
                 ip* ia1j* ia2j* 
                 op95 op00 os95 os00 oh95 oh00 om95 om00 
                 jp95 jp00  
                 ep95 ep00 ecf95 ecf00
                 jsfs jsfp jsfd esf,  
                 family(binomial) link(probit) cluster(journal);

mfx, varlist(jsfs jsfp jsfd esf);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;


**********************************************************************;
*** 1986-1995                                                      ***;
**********************************************************************;

clear;
use lt_temp;

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

* Build within-volume average covariates;
* Replaces fixed effects in Papke-Wooldridge (2008) method;

* When generate marginal effect, set other digitization variables at their means;
* Another approach would be to zero out all digitization variables, but more tedious;
* Another issue is whether to look at only subsets of data by cyear period or channel;
* Decide to project onto whole pyear block subsample;

sort volume;
foreach var of varlist ip* ia1j* ia2j* 
                        d1c* d2c* 
                        dp95 dp00 dh95 dh00 ds95 ds00 dm95 dm00
                        op95 op00 os95 os00 oh95 oh00 om95 om00 
                        jp95 jp00  
                        ep95 ep00 ecf95 ecf00
                        jfs95 jfs00 jfp95 jfp00 jfd95 jfd00 
                        ef95 ef00
                        jsfs jsfp jsfd esf {;
   by volume: egen m`var' = mean(`var');
};

save lt_temp_1, replace;


* Channel subscription specifications;

clear;
use lt_temp_1;

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

glm fraction_pos mip* mia1j* mia2j* 
                 mop95 mop00 mos95 mos00 moh95 moh00 mom95 mom00 
                 mjp95 mjp00  
                 mep95 mep00 mecf95 mecf00
                 mjsfs mjsfp mjsfd mesf
                 ip* ia1j* ia2j* 
                 op95 op00 os95 os00 oh95 oh00 om95 om00 
                 jp95 jp00  
                 ep95 ep00 ecf95 ecf00
                 jsfs jsfp jsfd esf,  
                 family(binomial) link(probit) cluster(journal);

mfx, varlist(jsfs jsfp jsfd esf);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;


**********************************************************************;
*** 1996-2005                                                      ***;
**********************************************************************;

clear;
use lt_temp;

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

* Build within-volume average covariates;
* Replaces fixed effects in Papke-Wooldridge (2008) method;

* When generate marginal effect, set other digitization variables at their means;
* Another approach would be to zero out all digitization variables, but more tedious;
* Another issue is whether to look at only subsets of data by cyear period or channel;
* Decide to project onto whole pyear block subsample;

sort volume;
foreach var of varlist ip* ia1j* ia2j* 
                        d1c* d2c* 
                        dp95 dp00 dh95 dh00 ds95 ds00 dm95 dm00
                        op95 op00 os95 os00 oh95 oh00 om95 om00 
                        jp95 jp00  
                        ep95 ep00 ecf95 ecf00
                        jfs95 jfs00 jfp95 jfp00 jfd95 jfd00 
                        ef95 ef00
                        jsfs jsfp jsfd esf {;
   by volume: egen m`var' = mean(`var');
};

save lt_temp_1, replace;

* Channel subscription specifications;

clear;
use lt_temp_1;

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

glm fraction_pos mip* mia1j* mia2j* 
                 mop95 mop00 mos95 mos00 moh95 moh00 mom95 mom00 
                 mjp95 mjp00  
                 mep95 mep00 mecf95 mecf00
                 mjsfs mjsfp mjsfd mesf
                 ip* ia1j* ia2j* 
                 op95 op00 os95 os00 oh95 oh00 om95 om00 
                 jp95 jp00  
                 ep95 ep00 ecf95 ecf00
                 jsfs jsfp jsfd esf,  
                 family(binomial) link(probit) cluster(journal);

mfx, varlist(jsfs jsfp jsfd esf);

* Stats for elasticities;
summ jsfs if jsfs > 0;
summ jsfp if jsfp > 0;
summ jsfd if jsfd > 0;
summ esf  if esf  > 0;


*********************************************;
* Remove temporary files to clean up disk ***;
*********************************************;

erase lt_temp_1.dta;
erase lt_temp.dta;
