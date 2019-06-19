/* This do file is to generate all the emprical results (tables and figures) in the main text of the paper ********************************************** */
/*********** paper title: Authority, Incentives, and Performance: Evidence from a Chinese Newspaper ********************************************** */
/*********** Author: Yanhui Wu, Department of Finance and Business Economics, University of Southern California ********************************** */
/*********** Date: July 15, 2015 ***************************************************************************************************************** */ 



/********************************************************** Table 1 ****************************************** */

/* Table 1. Panel A: Summary Statistics of Internal Performance Measures */
use "basic panel 04_06.dta", clear
sum articles words quantity quality 

/* Table 1. Panel B: Summary Statistics of Internal Performance Measures */
use "external measures.dta", clear
sum investigative feature special propaganda relation plan column co_author ex_author
reg quality articles words investigative feature special propaganda relation plan column co_author ex_author, cl(pid)


/* Table 2. Reporter Performance In Balanced Panel By Treatment and Reform */
use "basic panel 04_06.dta", clear
sort reform treatment
by reform treatment: sum lnquantity lnquality if remainder==1

reg lnquantity reform if treatment==1 & remainder==1, cl(cl_task)
reg lnquantity reform if control==1 & remainder==1, cl(cl_task)
reg lnquantity treatment if reform==0 & remainder==1, cl(cl_task)
reg lnquantity treatment if reform==1 & remainder==1, cl(cl_task)
reg lnquantity reform treatment reform_treatment if remainder==1, cl(cl_task)

reg lnquality reform if treatment==1 & remainder==1, cl(cl_task)
reg lnquality reform if control==1 & remainder==1, cl(cl_task)
reg lnquality treatment if reform==0 & remainder==1, cl(cl_task)
reg lnquality treatment if reform==1 & remainder==1, cl(cl_task)
reg lnquality reform treatment reform_treatment if remainder==1, cl(cl_task)

/********************************************************************* Table 3 **********************************************/
use "basic panel 04_06.dta", clear

local controls age2 tenure2 position2 position3 qualify2 qualify3
local sectiondummies econ politics localnews edu entertain generalnews consumption region

/* Table 3: Panel A */

/* baseline regression of the average treatment effect*/

/* dependent variables are logarithm of quantity */
areg lnquantity reform treatment reform_treatment, ab(pid) cl(cl_task)
areg lnquantity dym* treatment reform_treatment, ab(pid) cl(cl_task)
areg lnquantity `controls'  dym* `sectiondummies' reform_treatment, ab(pid) cl(cl_task)
areg lnquantity `sectiondummies' gendre uni_edu party age tenure `controls'  reform_treatment, ab(time) cl(cl_task)


/* dependent variables are logarithm of quality */

areg lnquality reform treatment reform_treatment, ab(pid) cl(cl_task)
areg lnquality dym* treatment reform_treatment, ab(pid) cl(cl_task)
areg lnquality `controls' dym* `sectiondummies' reform_treatment, ab(pid) cl(cl_task)
areg lnquality gendre uni_edu party age tenure `controls' `sectiondummies' reform_treatment, ab(time) cl(cl_task)

/* Table 3: Panel B dynamic treatment effects */
/* generate a set of lag and lead dummies */

 gen before0=time==200509 
 gen treat_before0=treatment*before0 
 gen before1=time==200508 
 gen treat_before1=treatment*before1 
 gen before2=time==200507 
 gen treat_before2=treatment*before2 
 gen after1=time==200510 
 gen treat_after1=treatment*after1 
 gen after2=time==200511 
 gen treat_after2=treatment*after2 
 gen after3=time==200512 
 gen treat_after3=treatment*after3 
 gen after4plus=time>200512 
 gen treat_after4plus=treatment*after4plus 


/* dependent variables are logarithm of quantity */
areg lnquantity `controls' dym* `sectiondummies' treat_*, ab(pid) cl(cl_task)
/* dependent variables are logarithm of quality */
areg lnquality `controls' dym* `sectiondummies' treat_*, ab(pid) cl(cl_task)


/******************************************************************** Table 4: Comparison of Individual Fixed Effects **********************************************/
use "basic panel 04_06.dta", clear
set matsize 1000

/* calculate individual fixed effects */
preserve

set matsize 1000
local controls age2 tenure2 position2 position3 qualify2 qualify3
local sectiondummies econ politics localnews edu entertain generalnews consumption region

qui xi: reg lnquality i.pid
qui for var  _Ipid_*: gen DX=X
/* gen D_Iworkerid_302=0; */
/* replace D_Iworkerid_302=1 if workerid==302; */
qui for var D_I*: gen RX=reform*X

/* take the residual from the regression of lnquality */
/* drop constant term so that the worker fixed effects are not relative to some omitted worker */
qui xi: reg lnquality D_Ipid* RD_Ipid* `controls' dym* `sectiondummies', cl(cl_task) nocons
gen qualityfe_before=.
gen qualityfe_after=.
gen qualityfe_diff=.

local i=1
while `i'<=232 {
capture replace qualityfe_before=_b[D_Ipid_`i']  if pid==`i'
capture replace qualityfe_before=.                    if qualityfe_before ==0  & pid==`i' 
capture replace qualityfe_diff=_b[RD_Ipid_`i'] if pid==`i'
capture replace qualityfe_diff=.                    if qualityfe_diff==0 & pid==`i'
capture replace qualityfe_after=qualityfe_before+qualityfe_diff    if pid==`i'
local i=`i'+1
}

/* take the residual from the regression of lnquantity */
/* drop constant term so that the worker fixed effects are not relative to some omitted worker */
qui xi: reg lnquantity D_Ipid* RD_Ipid* `controls' dym* `sectiondummies', cl(cl_task) nocons
gen quantityfe_before=.
gen quantityfe_after=.
gen quantityfe_diff=.

local i=1
while `i'<=232 {
capture replace quantityfe_before=_b[D_Ipid_`i']  if pid==`i'
capture replace quantityfe_before=.                    if quantityfe_before ==0  & pid==`i' 
capture replace quantityfe_diff=_b[RD_Ipid_`i'] if pid==`i'
capture replace quantityfe_diff=.                    if quantityfe_diff==0 & pid==`i' 
capture replace quantityfe_after=quantityfe_before+quantityfe_diff    if pid==`i'
local i=`i'+1
}

/* show the mean results before collapsing the data */



collapse quantity quality lnquantity lnquality quantityfe_before quantityfe_after quantityfe_diff qualityfe_before qualityfe_after qualityfe_diff ///
treatment control remainder switcher exit exit_treatment exit_control entry entry_treatment entry_control cl_task, by(pid reform)

/* remainder in the treatment group */
sum quantityfe_before qualityfe_before if remainder==1 & treatment==1 & reform==0
sum quantityfe_after qualityfe_after if remainder==1 & treatment==1 & reform==1
/* remainder in the control group */
sum quantityfe_before qualityfe_before if remainder==1 & control==1 & reform==0
sum quantityfe_after qualityfe_after if remainder==1 & control==1 & reform==1

/* exits in the treatment group */
sum quantityfe_before qualityfe_before if exit==1 & treatment==1 & reform==0

/* exits in the control group */
sum quantityfe_before qualityfe_before if exit==1 & control==1 & reform==0

/* entries in the treatment group */
sum quantityfe_before qualityfe_before if entry==1 & treatment==1 & reform==1

/* entries in the control group */
sum quantityfe_before qualityfe_before if entry==1 & control==1 & reform==1

restore


/* ******************************************************************** Table 5 ***************************************************** */
use "external measures.dta", clear
local controls age2 tenure2 position2 position3 qualify2 qualify3
local sectiondummies econ politics localnews edu entertain generalnews consumption region

areg lnquantity `controls'  dym* `sectiondummies' reform_treatment, ab(pid) cl(cl_task)
areg lnquality `controls' dym* `sectiondummies' reform_treatment, ab(pid) cl(cl_task)
areg investigative `controls'  dym* `sectiondummies' reform_treatment, ab(pid) cl(cl_task)
areg feature `controls'  dym* `sectiondummies' reform_treatment, ab(pid) cl(cl_task)
areg relation `controls'  dym* `sectiondummies' reform_treatment, ab(pid) cl(cl_task)
areg editor_ini `controls'  dym* `sectiondummies' reform_treatment, ab(pid) cl(cl_task)

/********************************************************************** Table 6 ******************************************************* */
/* triple differences regression */

/* ***************************** Table 6: first two columns *************************** */

use "basic panel 04_06.dta", clear

gen hb_month=(month==1 | month==9)
gen reform_hb_month=reform*hb_month 


gen hb_month_treatment=hb_month*treatment
gen hb_month_control=hb_month*control
gen reform_hb_month_treatment=reform_hb_month*treatment
gen reform_hb_month_control=reform_hb_month*control

local controls age2 tenure2 position2 position3 qualify2 qualify3
local sectiondummies econ politics localnews edu entertain generalnews consumption region

areg lnquantity hb_month_treatment reform_hb_month `controls' `sectiondummies' dym* reform_treatment reform_hb_month_treatment, ab(pid) cl(cl_task) 
test reform_treatment=-reform_hb_month_treatment

areg lnquality hb_month_treatment reform_hb_month `controls' `sectiondummies' dym* reform_treatment reform_hb_month_treatment, ab(pid) cl(cl_task) 
test reform_treatment=-reform_hb_month_treatment

/* **************************** Last three columns *************************** */
use "external measures.dta", clear
gen hb_month=(month==1 | month==9)
gen reform_hb_month=reform*hb_month 


gen hb_month_treatment=hb_month*treatment
gen hb_month_control=hb_month*control
gen reform_hb_month_treatment=reform_hb_month*treatment
gen reform_hb_month_control=reform_hb_month*control


local controls age2 tenure2 position2 position3 qualify2 qualify3
local sectiondummies econ politics localnews edu entertain generalnews consumption region

areg reporter_ini1 hb_month_treatment reform_hb_month `controls' `sectiondummies' dym* reform_treatment reform_hb_month_treatment, ab(pid) cl(cl_task) 
test reform_treatment=-reform_hb_month_treatment


areg relation hb_month_treatment reform_hb_month `controls' `sectiondummies' dym* reform_treatment reform_hb_month_treatment, ab(pid) cl(cl_task) 
test reform_treatment=-reform_hb_month_treatment

areg editor_ini hb_month_treatment reform_hb_month `controls' `sectiondummies' dym* reform_treatment reform_hb_month_treatment, ab(pid) cl(cl_task) 
test reform_treatment=-reform_hb_month_treatment


/* ********************************************************************  Table 7 ************************************************************** */

/******************************* Table 7: first two columns ***************** */
use "basic panel 04_06.dta", clear

local controls age2 tenure2 position2 position3 qualify2 qualify3
local sectiondummies econ politics localnews edu entertain generalnews consumption region

areg lnquantity `controls' dym* `sectiondummies' reform_economy reform_gov_pol reform_sci_edu reform_general, ab(pid) cl(cl_task)
areg lnquality `controls' dym* `sectiondummies' reform_economy reform_gov_pol reform_sci_edu reform_general, ab(pid) cl(cl_task)

/* *************************** last three columns ******************** */
use "external measures.dta", clear
local controls age2 tenure2 position2 position3 qualify2 qualify3
local sectiondummies econ politics localnews edu entertain generalnews consumption region

areg reporter_ini1 `controls' dym* `sectiondummies' reform_economy reform_gov_pol reform_sci_edu reform_general, ab(pid) cl(cl_task)
areg relation `controls' dym* `sectiondummies' reform_economy reform_gov_pol reform_sci_edu reform_general, ab(pid) cl(cl_task)
areg editor_ini `controls' dym* `sectiondummies' reform_economy reform_gov_pol reform_sci_edu reform_general, ab(pid) cl(cl_task)

/* ****************************************************** Figure 2 ******************************************** */
use "simplified_panel.dta", clear
set more off
preserve
gen timeindex=.
replace timeindex=1 if time==200401
replace timeindex=2 if time==200402
replace timeindex=3 if time==200403
replace timeindex=4 if time==200404
replace timeindex=5 if time==200405
replace timeindex=6 if time==200406
replace timeindex=7 if time==200407
replace timeindex=8 if time==200408
replace timeindex=9 if time==200409
replace timeindex=10 if time==200410
replace timeindex=11 if time==200411
replace timeindex=12 if time==200412

replace timeindex=13 if time==200501
replace timeindex=14 if time==200502
replace timeindex=15 if time==200503
replace timeindex=16 if time==200504
replace timeindex=17 if time==200505
replace timeindex=18 if time==200506
replace timeindex=19 if time==200507
replace timeindex=20 if time==200508
replace timeindex=21 if time==200509
replace timeindex=22 if time==200510
replace timeindex=23 if time==200511
replace timeindex=24 if time==200512

replace timeindex=25 if time==200601
replace timeindex=26 if time==200602
replace timeindex=27 if time==200603
replace timeindex=28 if time==200604
replace timeindex=29 if time==200605
replace timeindex=30 if time==200606
replace timeindex=31 if time==200607
replace timeindex=32 if time==200608
replace timeindex=33 if time==200609
replace timeindex=34 if time==200610
replace timeindex=35 if time==200611
replace timeindex=36 if time==200612



sort time
egen mt_lnquantity=mean (lnquantity) if treatment==1 & remainder==1, by (time)
egen mc_lnquantity=mean (lnquantity) if control==1 & remainder==1 & sumscore>1000, by (time)
egen ml_lnquantity=mean (lnquantity) if control_local==1, by(time)

egen mt_lnquality=mean (lnquality) if treatment==1 & remainder==1, by (time)
egen mc_lnquality=mean (lnquality) if control==1 & remainder==1 & sumscore>1000, by (time)
egen ml_lnquality=mean (lnquality) if control_local==1, by(time)


cap label drop timeindex
label define timeindex 1 "Jan. 2004" 13 "Jan. 2005" 21 "Sep. 2005" 25 "Jan. 2006" 37 "Dec. 2006"
label values timeindex timeindex

/* draw graph on the difference between the treatment and the control */
collapse mt_lnquantity mc_lnquantity ml_lnquantity mt_lnquality mc_lnquality ml_lnquality time, by (timeindex)
gen dif_tc_lnquantity=mt_lnquantity-mc_lnquantity
gen dif_tc_lnquality=mt_lnquality-mc_lnquality
gen dif_tcl_lnquantity=mt_lnquantity-ml_lnquantity
gen dif_tcl_lnquality=mt_lnquality-ml_lnquality


graph twoway line dif_tc_lnquantity dif_tcl_lnquantity timeindex, scheme(s2mono) legen(label (1 "Control: Entire Group") label (2 "Control: Local News")) xlabel(1(12)37,val angle(280)) xline(21, lpattern(shortdash)) ytitle("Difference in Log quantity") xtitle("") graphregion(fcolor(white))

graph twoway line dif_tc_lnquality dif_tcl_lnquality timeindex, scheme(s2mono) legen(label (1 "Control: Entire Group") label (2 "Control: Local News")) xlabel(1(12)37,val angle(280)) xline(21, lpattern(shortdash)) ytitle("Difference in Log quality") xtitle("") graphregion(fcolor(white))

restore


