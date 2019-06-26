#delimit ;
clear;
set memory 64m;
set more off;
cap log close;


log using C:\bs_riots.log, replace;

use C:\bs_riots.dta, clear;

tsset STATE_NB YEAR;
gen LOG_CNTV = ln(.1 + CNTVIOL);
gen LOG_CNTV1 = ln(.1 + CNTVIOL1);


* ******************************************************************    *;
*   CREATE GLOBAL VARIABLE LISTS;
* ******************************************************************    *;

global nb_invar = "NVOTES COALGOV URBGINI CNTVIOL1 CNTV_ADJ LPOP MUS MUSSQ LIT GDPPER";
global nb_fixed = "NVOTES COALGOV URBGINI CNTVIOL1 CNTV_ADJ LPOP 
 Istate1 Istate3 Istate4 Istate6 Istate7 Istate10 Istate11
 Istate12 Istate13 Istate18 Istate22 Istate24 Istate25";

global ll_invar = "NVOTES COALGOV URBGINI LOG_CNTV1 CNTV_ADJ LPOP MUS MUSSQ LIT GDPPER";
global ll_fixed = "NVOTES COALGOV URBGINI LOG_CNTV1 CNTV_ADJ LPOP
 Istate1 Istate3 Istate4 Istate6 Istate7 Istate10 Istate11
 Istate12 Istate13 Istate18 Istate19 Istate22 Istate24 Istate25";

global year_effects = "Iyear33 Iyear34 Iyear35 Iyear36 Iyear37 Iyear38 Iyear39 Iyear40 Iyear41 Iyear42 Iyear43 Iyear44 Iyear45";


* ******************************************************************    *;
*   TABLE I: DESCRIPTIVE STATISTICS;
* ******************************************************************    *;

summ CNTVIOL CNTVIOL1 LOG_CNTV LOG_CNTV1 CNTV_ADJ GROWTH GROWTH1 NVOTES COALGOV URBGINI LPOP MUS MUSSQ LIT GDPPER RAIN RAIN1;
centile CNTVIOL CNTVIOL1 LOG_CNTV LOG_CNTV1 CNTV_ADJ GROWTH GROWTH1 NVOTES COALGOV URBGINI LPOP MUS MUSSQ LIT GDPPER RAIN RAIN1;



* ******************************************************************    *;
*   TABLE II: COUNT & GROWTH AVERAGES BY STATE;
* ******************************************************************    *;

preserve;

collapse (count) YEAR (mean) CNTVIOL GROWTH, by(STATE);
gsort -CNTVIOL;
list;

restore;



* ******************************************************************    *;
*  TABLE III: NEGATIVE BI-NOMIAL RESULTS;
* ******************************************************************    *;

/* BASE */

nbreg CNTVIOL GROWTH GROWTH1 $nb_invar, cluster(STATE_NB) nolog;
est store nb;

* mfx compute, at(median);


/* WITH FIXED EFFECTS */

nbreg CNTVIOL GROWTH GROWTH1 $nb_fixed if STATE_NB != 19, cluster(STATE_NB) nolog;
est store nbfe;

* mfx compute, at(median);


/* WITH FIXED EFFECTS & YEAR EFFECTS */

nbreg CNTVIOL GROWTH GROWTH1 $nb_fixed $year_effects if STATE_NB != 19, cluster(STATE_NB) nolog;
est store nbfeye;

* mfx compute, at(median);


est table nb nbfe nbfeye, se stats(N ll chi2) b(%9.3f);
est table nb nbfe nbfeye, star(.10 .05 .01) b(%9.3f);



* ******************************************************************    *;
*  TABLE IV: LOG-LINEAR RESULTS NON-IV & IV;
* ******************************************************************    *;

/* NON-IV BASE */

reg LOG_CNTV GROWTH GROWTH1 $ll_invar, cluster(STATE_NB);
est store ll;


/* NON-IV WITH FIXED EFFECTS & YEAR EFFECTS */

reg LOG_CNTV GROWTH GROWTH1 $ll_fixed $year_effects, cluster(STATE_NB);
est store llfe;


/* IV BASE */

ivreg LOG_CNTV ( GROWTH GROWTH1 = RAIN RAIN1 $ll_invar) $ll_invar, cluster(STATE_NB);
est store lliv;


/* IV WITH FIXED EFFECTS & YEAR EFFECTS */

ivreg LOG_CNTV ( GROWTH GROWTH1 = RAIN RAIN1 $ll_fixed $year_effects) $ll_fixed $year_effects, cluster(STATE_NB);
est store llivfe;


est table ll llfe lliv llivfe, se stats(N ll chi2) b(%9.3f);
est table ll llfe lliv llivfe, star(.10 .05 .01) b(%9.3f);



* ******************************************************************    *;
*  APPENDIX TABLE I: IV DIAGNOSTICS;
* ******************************************************************    *;

/* FIRST STAGE RESULTS */

regress GROWTH RAIN RAIN1 $ll_invar, cluster(STATE_NB);
est store G;
test RAIN RAIN1;
qui regress GROWTH RAIN RAIN1 $ll_invar, robust;
test RAIN RAIN1;

regress GROWTH1 RAIN RAIN1 $ll_invar, cluster(STATE_NB);
est store Gl;
test RAIN RAIN1;
qui regress GROWTH RAIN RAIN1 $ll_invar, robust;
test RAIN RAIN1;

regress GROWTH RAIN RAIN1 $ll_fixed $year_effects, cluster(STATE_NB);
est store G_FE;
test RAIN RAIN1;
qui regress GROWTH RAIN RAIN1 $ll_fixed $year_effects, robust;
test RAIN RAIN1;

regress GROWTH1 RAIN RAIN1 $ll_fixed $year_effects, cluster(STATE_NB);
est store Gl_FE;
test RAIN RAIN1;
qui regress GROWTH RAIN RAIN1 $ll_fixed $year_effects, robust;
test RAIN RAIN1;


est table G Gl G_FE Gl_FE, se stats(N ll chi2) b(%9.3f);
est table G Gl G_FE Gl_FE, star(.10 .05 .01) b(%9.3f);


/* REDUCED FORM REGRESSIONS */

regress LOG_CNTV RAIN RAIN1 $ll_invar, cluster(STATE_NB);
est store RED;
regress LOG_CNTV RAIN RAIN1 $ll_fixed $year_effects, cluster(STATE_NB);
est store RED_FE;

est table RED RED_FE, se stats(N ll chi2) b(%9.3f);
est table RED RED_FE, star(.10 .05 .01) b(%9.3f);


log c;
exit;
