***Last Updated: 12/14/2018 using Stata14
/*==========================================*
Paper:			Breaking the Cycle? Education and the Intergenerational Transmission of Violence

Purpose:        Produce the results for multiple hypothesis testing using Romano-Wolf algorithm. 
Code is adopted from the original ado file written by Damian Clarke (Universidad de Santiago de Chile).

To re-run our analysis, please install a folder "Domestic Violence". There should be 5 subfolders in order for do-files to run:

"originals"
"created"
"do files"
"graphs"
"output"

Before you run this do file, please change the path of the working directory in line 24 and run all of the data cleaning do files.
*==========================================*/
clear
set more off 
set matsize 8000
cap log close
#delimit ;
global dir="XXX\Domestic Violence";
cd "$dir";
********************************************************************************

*! rwolf: Romano Wolf stepdown hypothesis testing algorithm
*! Original Author: Damian Clarke
*! Department of Economics
*! Universidad de Santiago de Chile
*! damian.clarke@usach.cl

cap program drop rwolf2
program rwolf2, eclass
vers 11.0
#delimit ;
syntax varlist(min=1 fv ts numeric) [if] [in] [pweight fweight aweight iweight],
indepvar(varlist max=1)
[
 method(name)
 controls(varlist fv ts)
 seed(numlist integer >0 max=1)
 reps(integer 100)
 Verbose
 strata(varlist)
 otherendog(varlist)
 cluster(varlist)
 iv(varlist)
 indepexog
 *
 ]
;
#delimit cr
cap set seed `seed'
if `"`method'"'=="" local method regress
if `"`method'"'=="ivreg2"|`"`method'"'=="ivreg" {
    dis as error "To estimate IV regression models, specify method(ivregress)"
    exit 200
}
if `"`method'"'!="ivregress"&length(`"`indepexog'"')>0 {
    dis as error "indepexog argument can only be specified with method(ivregress)"
    exit 200
}
if `"`method'"'=="ivregress" {
    local ivr1 "("
    local ivr2 "=`iv')"
    local method ivregress 2sls
    if length(`"`iv'"')==0 {
        dis as error "Instrumental variable(s) must be included when specifying ivregress"
        dis as error "Specify the IVs using iv(varlist)"
        exit 200
    }    
}
else {
    local ivr1
    local ivr2
    local otherendog
}

local bopts
if length(`"`strata'"')!=0  local bopts `bopts' strata(`strata')
if length(`"`cluster'"')!=0 local bopts `bopts' cluster(`cluster')

*-------------------------------------------------------------------------------
*--- Run bootstrap reps to create null Studentized distribution
*-------------------------------------------------------------------------------    
local j=0
local cand
local wt [`weight' `exp']

tempname nullvals
tempfile nullfile
file open `nullvals' using "`nullfile'", write all


foreach var of varlist `varlist' {
    local ++j
    if length(`"`indepexog'"')==0 {
        `method' `var' `ivr1'`indepvar'  `otherendog'`ivr2' `controls' `if' `in' `wt', `options'
    }
    else {
        `method' `var' `ivr1'`otherendog'`ivr2' `indepvar' `controls' `if' `in' `wt', `options'
    }
    if _rc!=0 {
        dis as error "Your original `method' does not work."
        dis as error "Please test the `method' and try again."
        exit _rc
    }
    local t`j' = abs(_b[`indepvar']/_se[`indepvar'])
    local n`j' = e(N)-e(rank)
    if `"`method'"'=="areg" local n`j' = e(df_r)
    local cand `cand' `j'
    
    file write `nullvals' "b`j'; se`j';"
}


dis "Running `reps' bootstrap replications for each variable.  This may take some time"
forvalues i=1/`reps' {
    if length(`"`verbose'"')!=0 dis "Bootstrap sample `i'."
    local j=0
    preserve
    bsample `if' `in', `bopts'
    
    foreach var of varlist `varlist' {
        local ++j
        if length(`"`indepexog'"')==0 {
            qui `method' `var' `ivr1'`indepvar'  `otherendog'`ivr2' `controls' `if' `in' `wt', `options'
        }
        else {
            qui `method' `var' `ivr1'`otherendog'`ivr2' `indepvar' `controls' `if' `in' `wt', `options'
        }
        if `j'==1 file write `nullvals' _n "`= _b[`indepvar']';`= _se[`indepvar']'"
        else file write `nullvals' ";`= _b[`indepvar']';`= _se[`indepvar']'"
    }
    restore
}

preserve
file close `nullvals'
qui insheet using `nullfile', delim(";") names clear

*-------------------------------------------------------------------------------
*--- Create null t-distribution
*-------------------------------------------------------------------------------
foreach num of numlist 1(1)`j' {
    qui sum b`num'
    qui replace b`num'=abs((b`num'-r(mean))/se`num')
}

*-------------------------------------------------------------------------------
*--- Create stepdown value in descending order based on t-stats
*-------------------------------------------------------------------------------
local maxt = 0
local pval = 0
local rank

while length("`cand'")!=0 {
    local donor_tvals

    foreach var of local cand {
        if `t`var''>`maxt' {
            local maxt = `t`var''
            local maxv `var'
        }
        qui dis "Maximum t among remaining candidates is `maxt' (variable `maxv')"
        local donor_tvals `donor_tvals' b`var'
    }
    qui egen empiricalDist = rowmax(`donor_tvals')
    sort empiricalDist
    forvalues cnum = 1(1)`reps' {
        qui sum empiricalDist in `cnum'
        local cval = r(mean)
        if `maxt'>`cval' {
            local pval = 1-((`cnum'+1)/(`reps'+1))
        }
    }
    qui gen empiricalDistOrig = b`maxv'
    sort empiricalDistOrig
    forvalues cnum = 1(1)`reps' {
        qui sum empiricalDistOrig in `cnum'
        local cval = r(mean)
        if `maxt'>`cval' {
            local pvalBS = 1-((`cnum'+1)/(`reps'+1))
        }
    }
    local prm`maxv's  = `pval'
    local prm`maxv'BS = `pvalBS'
    if length(`"`prmsm1'"')!=0 local prm`maxv's=max(`prm`maxv's',`prmsm1')
    local p`maxv'   = string(ttail(`n`maxv'',`maxt')*2,"%6.4f")
    if `"`method'"'=="ivregress 2sls" local p`maxv'   = string((1-normal(abs(`maxt')))*2,"%6.4f")
    local prm`maxv'   = string(`prm`maxv's',"%6.4f")
    local prm`maxv'BS = string(`prm`maxv'BS',"%6.4f")
    local prmsm1 = `prm`maxv's'
    
    drop empiricalDist empiricalDistOrig
    local rank `rank' `maxv'
    local candnew
    foreach c of local cand {
        local match = 0
        foreach r of local rank {
            if `r'==`c' local match = 1
        }
        if `match'==0 local candnew `candnew' `c'
    }
    local cand `candnew'
    local maxt = 0
    local maxv = 0
}

restore

*-------------------------------------------------------------------------------
*--- Report and export p-values
*-------------------------------------------------------------------------------
local j=0
dis _newline
foreach var of varlist `varlist' {
    local ++j
    local ORIG "Original p-value is `p`j''"
    local BS "Original (bootstrap) p-value is `prm`j'BS'"
    local RW "Romano Wolf p-value is `prm`j''"
    dis "For the variable `var': `ORIG'. `BS'. `RW'."
    ereturn scalar rw_`var'=`prm`j's'
}   

end

********************************************************************************

use "created/women_data_for_analysis_2014.dta", clear

log using "output/results_rwolf_5555_50.log", replace

global contr="month_* noturkish2 region_pre12_* region_pre12i* rural_pre12"
global se "cluster modate"	
global slvl "starlevels(* 0.10 ** 0.05 *** 0.01)"

********** TABLE A18: EDUCATION EFFECTS ON CHILDHOOD VIOLENCE
**FULL SAMPLE
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(schooling) controls(month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(after1986) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(schooling) iv(after1986) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL SAMPLE
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & rural_pre12==1
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(schooling) controls(month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(after1986) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(schooling) iv(after1986) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

**URBAN SAMPLE
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & rural_pre12==0
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(schooling) controls(month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(after1986) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 violence_family violence_family_often [aw=womenweight], indepvar(schooling) iv(after1986) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

********* TABLE A19: RD TREATMENT EFFECTS ON SCHOOLING (SAMPLE OF ALL WOMEN)
**FULL SAMPLE
*linear RD, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85
rwolf2 schooling jhighschool highschool primaryschool [aw=womenweight], indepvar(after1986) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, 0.75 h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85*0.75
rwolf2 schooling jhighschool highschool primaryschool [aw=womenweight], indepvar(after1986) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, 1.5 h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85*1.5
rwolf2 schooling jhighschool highschool primaryschool [aw=womenweight], indepvar(after1986) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**Note: Table 3 has only one variable, so there is no multiple hypothesis testing.

********** TABLE A20: EDUCATION EFFECTS ON VIOLENCE AGAINST CHILDREN 
********** TABLE A20, PANEL A: RD TREATMENT EFFECTS
**FULL SAMPLE
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling) controls(month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(after1986) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling) iv(after1986) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL SAMPLE
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1 & rural_pre12==1
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling) controls(month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(after1986) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling) iv(after1986) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8) vce(cluster modate) seed(5555) reps(50)

********** TABLE A20, PANEL B: RD TREATMENT EFFECTS BY EXPOSURE TO CHILDHOOD VIOLENCE
**FULL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1 & rural_pre12==1
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986_family after1986) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 hit_child hit_child_often [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

********** TABLE A21: EFFECTS OF EDUCATION ON CHILD BEHAVIOR
**FULL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1 & rural_pre12==1
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 child_aggressive child_nightmare child_peebed child_shy child_cry_aggressive [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

********** TABLE A22: EFFECTS OF EDUCATION ON ATTITUDES TOWARDS VIOLENCE
**FULL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1 & rural_pre12==1
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 agree_beat agree_childbeat [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

********** TABLE A23: : EFFECTS OF EDUCATION ON MATERNAL MENTAL HEALTH
**FULL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1 & rural_pre12==1
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_depression z_somatic z_nonsomatic [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

********** TABLE A24: EFFECTS OF EDUCATION ON FERTILITY OUTCOMES
**FULL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & rural_pre12==1
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 pregnancy_age num_children [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

********** TABLE A25: EFFECTS OF EDUCATION ON LABOR MARKET OUTCOMES
**FULL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1 & rural_pre12==1
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 work_lastweek service social_security z_income z_asset [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

********** TABLE A26: EFFECTS OF EDUCATION ON PARTNER CHARACTERISTICS AND MARRIAGE MARKET OUTCOMES
**FULL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1 & rural_pre12==1
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 schooling_partner husband_age z_malereligious marriage_age marriage_decision divorced [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

********** TABLE A27: EFFECTS OF EDUCATION ON SPOUSAL VIOLENCE
**FULL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 rural_pre12 region_pre12i1 region_pre12i2 region_pre12i3 region_pre12i4 region_pre12i5 region_pre12i6 region_pre12i7 region_pre12i8 region_pre12i9 region_pre12i10 region_pre12i11) vce(cluster modate) seed(5555) reps(50)

**RURAL, with interaction, family
**OLS, h bandwidth, with controls
use "created/women_data_for_analysis_2014.dta", clear
keep if abs(dif)<85 & has_children==1 & rural_pre12==1
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(schooling) controls(schooling_family violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(schooling_family) controls(schooling violence_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(violence_family) controls(schooling schooling_family month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD, h bandwidth, with controls
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(after1986) controls(after1986_family violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(after1986_family) controls(after1986 violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(violence_family) controls(after1986 after1986_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)

**linear RD-2SLS, h bandwidth, with controls
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(schooling) otherendog(schooling_family) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(schooling_family) otherendog(schooling) iv(after1986 after1986_family) method(ivregress) controls(violence_family di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
rwolf2 z_physical z_emotional z_financial [aw=womenweight], indepvar(violence_family) otherendog(schooling schooling_family) indepexog iv(after1986 after1986_family) method(ivregress) controls(di1 di1_i month_1 month_10 month_11 month_12 month_2 month_3 month_4 month_5 month_6 month_7 month_8 noturkish2 region_pre12_1 region_pre12_10 region_pre12_11 region_pre12_12 region_pre12_2 region_pre12_3 region_pre12_4 region_pre12_5 region_pre12_6 region_pre12_7 region_pre12_8 ) vce(cluster modate) seed(5555) reps(50)
