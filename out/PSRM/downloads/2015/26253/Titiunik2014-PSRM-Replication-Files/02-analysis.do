#delimit;
clear all;
cap log close;
set more off;
set mem 1000m;
set matsize 300;
program drop _all;
postutil clear;


/*************************************

Pogram to run regressions and post results

**************************************/

program define posteffects;
   args y treat controls ifcondition description alpha postname state;
   reg `y' `treat' `controls' `ifcondition';
   local k: length local ifcondition;
   if(`k' == 0) local ifcondition2 "";
   else local ifcondition2: subinstr local ifcondition "if" "&";
   mat b  = e(b);
   mat v = vecdiag(e(V));
   local N = e(N);
   local coef = b[1,1];
   local se = sqrt(v[1,1]);
   local t = `coef'/`se';
   local pval = 2*ttail(`N',abs(`t'));
   local cil = `coef' - invttail(`N',`alpha'/2)*`se';
   local ciu = `coef' + invttail(`N',`alpha'/2)*`se';
   summarize `y' if `treat'==1 `ifcondition2';
   local meantr = r(mean);
   summarize `y' if `treat'==0 `ifcondition2';
   local meanco = r(mean);
   post `postname' ("`state'") ("`y'") ("`description'") (`meantr') (`meanco') (`coef') (`se') (`pval') (`cil') (`ciu') (`t') ;
end;   



/*************************************

Create post file to store results

**************************************/

postfile results  str20 (state varname description) meantr meanco coef se pval cil ciu t using "./output/estimation-results.dta", replace;


/*************************************

TEXAS: Pool 1993 and 1995 together

**************************************/

use "./dataTX-final.dta", clear;
keep if year == 1993 | year == 1995;


**************************;
* Abstention outcomes
******************;

reg aepc_rate dshort_term;
local x  "";
local if "";
local des "all";
posteffects aepc_rate dshort_term "`x'" "`if'" "`des'" 0.05 results Texas9395;

* Placebo subsample;
reg aepc_ratePL dshort_term;
posteffects aepc_ratePL dshort_term "" "" "all" 0.05 results Texas9395;

* Post-Placebo subsample;
reg aepc_ratePPL dshort_term;
posteffects aepc_ratePPL dshort_term "" "" "all" 0.05 results Texas9395;

**************************;
* Bill introduction outcomes;
**************************;
* Levels;
reg num_bls_int_sen_aut dshort_term;
posteffects num_bls_int_sen_aut dshort_term "" ""                        "all"       0.05 results Texas9395;

**************************;
* Responsiveness;
**************************;
reg absnom dshort_term;
posteffects absnom dshort_term "" ""                        "all"       0.05 results Texas9395;

reg distance dshort_term;
posteffects distance dshort_term "" ""                        "all"       0.05 results Texas9395;

**************************;
* Campaign cont and exp;
**************************;
reg  cont_total_firstsem dshort_term;
reg  cont_total_lastsem dshort_term;
reg  exp_total_firstsem  dshort_term;
reg  exp_total_lastsem  dshort_term;

posteffects cont_total_firstsem dshort_term "" ""                        "all"       0.05 results Texas9395;
posteffects cont_total_lastsem dshort_term "" ""                        "all"       0.05 results Texas9395;
posteffects exp_total_firstsem dshort_term "" ""                        "all"       0.05 results Texas9395;
posteffects exp_total_lastsem dshort_term "" ""                        "all"       0.05 results Texas9395;


/*************************************

TEXAS: 2003 separately

**************************************/

use "./dataTX-final.dta", clear;
keep if year == 2003;


**************************;
* Abstention outcomes
******************;

reg aepc_rate dshort_term;
local x  "";
local if "";
local des "all";
posteffects aepc_rate dshort_term "`x'" "`if'" "`des'" 0.05 results Texas2003;

**************************;
* Bill introduction outcomes;
**************************;
* Levels;
reg num_bls_int_sen_aut dshort_term;

**************************;
* Responsiveness;
**************************;
reg absnom dshort_term;
posteffects absnom dshort_term "" ""                        "all"       0.05 results Texas2003;

reg distance dshort_term;
posteffects distance dshort_term "" ""                        "all"       0.05 results Texas2003;

**************************;
* Campaign cont and exp;
**************************;
reg  cont_total_firstsem dshort_term;
reg  cont_total_lastsem dshort_term;
reg  exp_total_firstsem  dshort_term;
reg  exp_total_lastsem  dshort_term;

posteffects cont_total_firstsem dshort_term "" ""                        "all"       0.05 results Texas2003;
posteffects cont_total_lastsem dshort_term "" ""                        "all"       0.05 results Texas2003;
posteffects exp_total_firstsem dshort_term "" ""                        "all"       0.05 results Texas2003;
posteffects exp_total_lastsem dshort_term "" ""                        "all"       0.05 results Texas2003;

/*************************************

ARKANSAS

**************************************/

use "./dataAR-final.dta", clear;


**************************;
* Abstention outcomes
******************;

reg aepc_rate dshort_term;
posteffects aepc_rate dshort_term "" "" "all" 0.05 results Arkansas;

**************************;
* Bill introduction outcomes;
**************************;
* Levels;
reg num_bls_int_sen_aut dshort_term;
posteffects num_bls_int_sen_aut dshort_term "" ""                        "all"       0.05 results Arkansas;

**************************;
* Responsiveness;
**************************;
reg absnom dshort_term;
posteffects absnom dshort_term "" ""                        "all"       0.05 results Arkansas;

reg distance dshort_term;
posteffects distance dshort_term "" ""                        "all"       0.05 results Arkansas;

**************************;
* Campaign cont and exp;
**************************;

posteffects cont_total_firstsem dshort_term "" ""                        "all"       0.05 results Arkansas;
posteffects cont_total_lastsem dshort_term "" ""                        "all"       0.05 results Arkansas;
posteffects exp_total_firstsem dshort_term "" ""                        "all"       0.05 results Arkansas;
posteffects exp_total_lastsem dshort_term "" ""                        "all"       0.05 results Arkansas;


/*************************************

ILLINOIS

**************************************/

use "./dataIL-final.dta", clear;
rename abs_rate aepc_rate;

**************************;
* Abstention outcomes
******************;

reg aepc_rate dshort_term;
posteffects aepc_rate dshort_term "" "" "all" 0.05 results Illinois;

**************************;
* Bill introduction outcomes;
**************************;
* Levels;
reg num_bls_int_sen_aut dshort_term;

**************************;
* Responsiveness;
**************************;
reg absnom dshort_term;
posteffects absnom dshort_term "" ""                        "all"       0.05 results Illinois;

reg distance dshort_term;
posteffects distance dshort_term "" ""                        "all"       0.05 results Illinois;

**************************;
* Campaign cont and exp;
**************************;

posteffects cont_total_firstsem dshort_term "" ""                        "all"       0.05 results Illinois;
posteffects cont_total_lastsem dshort_term "" ""                        "all"       0.05 results Illinois;
posteffects exp_total_firstsem dshort_term "" ""                        "all"       0.05 results Illinois;
posteffects exp_total_lastsem dshort_term "" ""                        "all"       0.05 results Illinois;

postclose results;



