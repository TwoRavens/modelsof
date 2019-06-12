

cap log close
log using replication.log, replace
set more off


*** THE MARKET FOR HIGH QUALITY MEDICINE: RETAIL CHAIN ENTRY AND DRUG QUALITY IN INDIA
*** DANIEL BENNETT AND WESLEY YIN
*** FEBRUARY 2018


*****************
** INTERACTION **
*****************

cap program drop ix
program define ix
cap gen `1'_`2'=`1'*`2'
end


******************************
** CREATE BASELINE VARIABLE **
******************************

capture program drop bse
program define bse
gen tv=`1' if round==1
bysort mkt_id pharm_id drg scenario: egen `1'b=max(tv)
drop tv
end

****************************
** PROPORTIONAL SELECTION **
****************************

* 1=LHS VARIABLE
* 2=CONTROLS
* 3=SUB-MARKET VARS FOR RMAX
* 4=ADDITIONS TO MAIN SPEC (E.G. WEIGHTS)

capture program drop psroutine
program define psroutine
quietly reg `1' mk_* post_mk_* `3'
global rmaxvar=e(r2)
quietly reg `1' post post_trt mk_* `2' `4'
psacalc delta post_trt, mcontrol(post mk_*) rmax($rmaxvar)
macro drop rmaxvar
end


****************************************************
** PROPORTIONAL SELECTION FOR 3-ROUND REGRESSIONS **
****************************************************

* 1=LHS VARIABLE
* 2=CONTROLS
* 3=WEIGHTS

capture program drop psroutine_3round
program define psroutine_3round
quietly reg `1' r2_mk* r3_mk* mk_* `3'
global rmaxvar=e(r2)
quietly reg `1' r2_trt r3_trt r2 r3 mk_* `2' `3'
psacalc delta r2_trt, mcontrol(r3_trt r2 r3 mk_*) rmax($rmaxvar)
psacalc delta r3_trt, mcontrol(r2_trt r2 r3 mk_*) rmax($rmaxvar)
macro drop rmaxvar
end


************
** MACROS **
************

global urc      "tag_unitround==1  & medplus~=1"	     		// UNIT-ROUND TAG
global prc      "tag_pharmround==1 & medplus~=1"		    	// PHARMACY-ROUND TAG
global demo_m   "inc_m edu_m deg_m cst_m tfw_m"					    // MARKET DEMOGRAPHICS
global hlth_m   "fevr_m diar_m cold_m injy_m"			    		// MARKET HEALTH STATUS
global demo_bix "inc_mb edu_mb deg_mb cst_mb tfw_mb post_inc_mb post_edu_mb post_deg_mb post_cst_mb post_tfw_mb"			     // BASELINE MARKET DEMOGRAPHICS X POST
global hlth_bix "fevr_mb diar_mb cold_mb injy_mb post_fevr_mb post_diar_mb post_cold_mb post_injy_mb"	     					// BASELINE MARKET HEALTH STATUS X POST
global supp_bix "retpctb signsb phageb tr_allb post_retpctb post_signsb post_phageb post_tr_allb" 						 		// BASELINE PHARMACY CHARACTERISTICS X POST




*****************
** IMPORT DATA **
*****************

import delimited traffic, clear
save traffic, replace

import delimited census, clear
save census, replace

import delimited consumer, clear
save consumer, replace

import delimited final, clear
save final, replace

import delimited hyd_weather, clear
save hyd_weather, replace





/*
************************************************************************************************************************
** FIGURE 1A: THE PRICE DISTRIBUTIONS FOR INDIAN PHARMACOPEIA COMPLIANT (I.E. HIGH QUALITY) AND NON-COMPLIANT SAMPLES **
************************************************************************************************************************

use final, clear
twoway kdensity pricepertab_usd if pass==1, bwidth(.01) scheme(s1mono) legend(label(1 "IP Compliant Samples")) || kdensity  pricepertab_usd if pass==0, bwidth(.01) lwidth(thick) legend(label(2 "IP Non-Compliant Samples")) ytitle(Kernel Density) xtitle(Price per 500mg Tablet (USD))

XXX
*/




/*
*******************************************************
** FIGURE 1B: ACTUAL AND PERCEIVED QUALITY BY MARKET ** 
*******************************************************

use final, clear
bysort mkt_id round: egen passm=mean(pass)
bysort mkt_id round: keep if _n==1

twoway (scatter qualm passm, msymbol(+) scheme(s1mono) xtitle(Marketwide Indian Pharmacopeia Compliance) ytitle(Perceived Quality Among Consumers) legend(off)) (lfit qualm passm)

XXX
*/





/*
*****************************************************************************************************
** FIGURE 2: BASELINE DISTRIBUTIONS OF NON-BINARY CHARACTERISTICS IN TREATMENT AND CONTROL MARKETS **
*****************************************************************************************************

use final, clear

local var pricepertab_usd
twoway kdensity `var' if trt==0 & round==1 & tag_unitround==1, scheme(s1mono) ylabel(0[15]15) lcolor(gs10) lwidth(thick) bwidth(0.012) xtitle(US Dollars) legend(label(1 "Control Markets")) || kdensity `var' if trt==1 & round==1 & tag_unitround==1, lcolor(black) lwidth(thick) lpattern(solid) bwidth(0.012) ytitle(Kernel Density) title(Price per Tablet) legend(label(2 "Treatment Markets")) legend(off)
graph save dens_prc.gph, replace
ksmirnov `var' if round==1 & tag_unitround==1, by(trt) exact

local var l_api_pct
twoway kdensity `var' if trt==0 & round==1 & tag_unitround==1, scheme(s1mono) bwidth(0.006) ylabel(0[30]30) lcolor(gs10) lwidth(thick) xtitle(Absolute Percent Deviation) legend(label(1 "Control Markets")) || kdensity `var' if trt==1 & round==1 & tag_unitround==1, lcolor(black) lwidth(thick) ytitle(Kernel Density) legend(label(2 "Treatment Markets")) legend(off) bwidth(0.006) title(Active Ingredient)
graph save dens_api.gph, replace
ksmirnov `var' if round==1 & tag_unitround==1, by(trt) exact

local var l_uniform_absmax
twoway kdensity `var' if trt==0 & round==1 & tag_unitround==1, scheme(s1mono) ylabel(0[0.8]0.8) lcolor(gs10) lwidth(thick) xtitle(Uniformity) bwidth(0.2)|| kdensity `var' if trt==1 & round==1 & tag_unitround==1, lcolor(black) lwidth(thick) ytitle(Kernel Density) legend(off) bwidth(0.2) title(Uniformity) 
graph save dens_uni.gph, replace
ksmirnov `var' if round==1 & tag_unitround==1, by(trt) exact

local var l_dissol_min
twoway kdensity `var' if trt==0 & round==1 & tag_unitround==1, scheme(s1mono) ylabel(0[0.15]0.15) lcolor(gs10) lwidth(thick) xtitle(Dissolution) bwidth(1) || kdensity `var' if trt==1 & round==1 & tag_unitround==1, lcolor(black) lwidth(thick) ytitle(Kernel Density) legend(off) title(Dissolution) bwidth(1) 
graph save dens_dis.gph, replace
ksmirnov `var' if round==1 & tag_unitround==1, by(trt) exact

local var tte
twoway kdensity `var' if trt==0 & round==1 & tag_unitround==1, scheme(s1mono) lcolor(gs10) lwidth(thick) xtitle(Days) bwidth(80) ylabel(0[0.002].002) || kdensity `var' if trt==1 & round==1 & tag_unitround==1, lcolor(black) lwidth(thick) ytitle(Kernel Density) legend(off) title(Days Until Expiry) bwidth(80)
graph save dens_tte.gph, replace
ksmirnov `var' if round==1 & tag_unitround==1, by(trt) exact

local var tr_all
twoway kdensity `var' if trt==0 & round==1 & tag_pharmround==1, scheme(s1mono) lcolor(gs10) lwidth(thick) xtitle(Number of Customers) bwidth(12) ylabel(0[0.02]0.02) || kdensity `var' if trt==1 & round==1 & tag_pharmround==1, lcolor(black) lwidth(thick) ytitle(Kernel Density) legend(off) title(Customer Traffic) bwidth(12)
graph save dens_trf.gph, replace
ksmirnov `var' if round==1 & tag_pharmround==1, by(trt) exact

local var distw
twoway kdensity `var' if trt==0 & round==1 & tag_pharmround==1, scheme(s1mono) lcolor(gs10) lwidth(thick) xtitle(Kilometers) bwidth(.2) ylabel(0[1.2]1.2) || kdensity `var' if trt==1 & round==1 & tag_pharmround==1, lcolor(black) lwidth(thick) ytitle(Kernel Density) legend(off) title(Distance to Market Center) bwidth(.2)
graph save dens_dmc.gph, replace
ksmirnov `var' if round==1 & tag_pharmround==1, by(trt) exact


use consumer, clear
local var ln_incr_usd
twoway kdensity `var' if trt==0 & round==1 & int_loc==2, bwidth(0.25) ylabel(0[1]1) scheme(s1mono) lcolor(gs10) lwidth(thick) xtitle(US Dollars) || kdensity `var' if trt==1 & round==1 & int_loc==2, bwidth(0.25) lcolor(black) lwidth(thick) ytitle(Kernel Density) title(Log Monthly Income) legend(off)
graph save dens_inc.gph, replace
ksmirnov `var' if round==1 & int_loc==2, by(trt) exact

local var edu_years
twoway hist `var' if trt==1 & round==1 & int_loc==2, scheme(s1mono) color(black) ylabel(0[0.15]0.15) start(0) width(2) || hist `var' if trt==0 & round==1 & int_loc==2, fcolor(none) lcolor(gs10) lwidth(thick) start(0) width(2) legend(off) xtitle(Years) ytitle(Frequency) title(Education)
graph save dens_edu.gph, replace
ksmirnov `var' if round==1 & int_loc==2, by(trt) exact

local var hsize
twoway hist `var' if trt==1 & round==1 & int_loc==2, scheme(s1mono) ylabel(0[0.4]0.4) color(black) start(2) width(1) || hist `var' if trt==0 & round==1 & int_loc==2, fcolor(none) lcolor(gs10) lwidth(thick) start(2) width(1) legend(off) xtitle(Household Size) ytitle(Frequency) title(Household Size)
graph save dens_hhs.gph, replace
ksmirnov `var' if round==1 & int_loc==2, by(trt) exact

grc1leg dens_prc.gph dens_api.gph dens_uni.gph dens_dis.gph dens_tte.gph dens_trf.gph dens_dmc.gph dens_inc.gph dens_edu.gph dens_hhs.gph, cols(2) rows(5) 	legendfrom(dens_prc.gph) scheme(s1mono) 
*/






/*
*****************************************
** FIGURE 3: QUALITY AND PRICE CHANGES **
*****************************************

use if tag_unitround==1 using final, clear

xtset unit round
set scheme s1mono

label var pass "Percent Compliance with Indian Pharmacopeia"
label var pricepertab_usd "Price per Tablet (2010 USD)"
label var round "Survey Round"

xtgraph pass if medplus==0, gr(trt) label 
graph save qualall.gph, replace

xtgraph pricepertab_usd if medplus==0, gr(trt) 
graph save priceall.gph, replace

graph combine qualall.gph priceall.gph, cols(1) rows(2) title("") scheme(s1mono) ysize(11) xsize(7)

XXX
*/





/*
**************************************************************************************
** FIGURE 4A: THE DENSITY OF ACTIVE INGREDIENT CONCENTRATION FOR NON-NATIONAL DRUGS **
**************************************************************************************

use final, clear

** CONTROL MARKETS
twoway kdensity l_api_pct_cont if round==1 & tag_unitround==1 & trt==0 & nn==1, title(Control Markets) lcolor(gs11) xlabel(80[5]115) ylabel(0[0.05].2) bwidth(1.5) scheme(s1mono) xtitle(% of Correct Level) ytitle(Kernel Density) legend(label(1 "Round 1")) lwidth(thick) || kdensity l_api_pct_cont if round==2 & tag_unitround==1 & trt==0 & nn==1, lcolor(black) bwidth(1.5) legend(label(2 "Round 2")) lwidth(thick)
graph save api_ctl.gph, replace
ksmirnov l_api_pct_cont, by(round), if tag_unitround==1 & trt==0 & nn==1

** TREATMENT MARKETS
twoway kdensity l_api_pct_cont if round==1 & tag_unitround==1 & trt==1 & nn==1, title(Treatment Markets) lcolor(gs11) xlabel(80[5]115) ylabel(0[0.05].2) bwidth(1.5) scheme(s1mono) xtitle(% of Correct Level) ytitle(Kernel Density) legend(label(1 "Round 1")) lwidth(thick) || kdensity l_api_pct_cont if round==2 & tag_unitround==1 & trt==1 & nn==1, lcolor(black) bwidth(1.5) legend(label(2 "Round 2")) lwidth(thick)
graph save api_trt.gph, replace
ksmirnov l_api_pct_cont, by(round), if tag_unitround==1 & trt==1 & nn==1

graph combine api_ctl.gph api_trt.gph, cols(2) rows(1) title("") scheme(s1mono) ysize(4) xsize(7)

XXX
*/


/*
******************************************************************
** FIGURE 4B: THE DENSITY OF DISSOLUTION FOR NON-NATIONAL DRUGS **
******************************************************************

use final, clear

** CONTROL MARKETS
twoway kdensity l_dissol_min if round==1 & tag_unitround==1 & trt==0 & nn==1, title(Control Markets) lcolor(gs11) xlabel(30[10]100) ylabel(0[0.05].15) bwidth(1.5) scheme(s1mono) xtitle(Dissolution) ytitle(Kernel Density) legend(label(1 "Round 1")) lwidth(thick) || kdensity l_dissol_min if round==2 & tag_unitround==1 & trt==0 & nn==1, lcolor(black) bwidth(1.5) legend(label(2 "Round 2")) lwidth(thick)
graph save dissol_ctl.gph, replace
ksmirnov l_dissol_min, by(round), if tag_unitround==1 & trt==0 & nn==1

** TREATMENT MARKETS
twoway kdensity l_dissol_min if round==1 & tag_unitround==1 & trt==1 & nn==1, title(Treatment Markets) lcolor(gs11) xlabel(30[10]100) ylabel(0[0.05].15) bwidth(1.5) scheme(s1mono) xtitle(Dissolution) ytitle(Kernel Density) legend(label(1 "Round 1")) lwidth(thick) || kdensity l_dissol_min if round==2 & tag_unitround==1 & trt==1 & nn==1, lcolor(black) bwidth(1.5) legend(label(2 "Round 2")) lwidth(thick)
graph save dissol_trt, replace
ksmirnov l_dissol_min, by(round), if tag_unitround==1 & trt==1 & nn==1

graph combine dissol_ctl.gph dissol_trt.gph, cols(2) rows(1) title("") scheme(s1color) ysize(4) xsize(7)
XXX
*/




*******************************************************************
** TABLE 1: BASELINE COMPARISON OF TREATMENT AND CONTROL MARKETS **
*******************************************************************

local panel_a  "pricepertab_usd pass l_api_pct l_uniform_absmax l_dissol_min tte"
local panel_b  "ph_ac ph_clean tr_all distw"
local panel_c "ln_incr_usd edu_years hsize scst tfw"


// PANEL A
use final, clear


foreach var in `panel_a' {
display "`var'"
ttest `var', by(trt), if round==1 & medplus==0 & tag_unitround==1 
}

// PANEL B
foreach var in `panel_b' {
display "`var'"
ttest `var', by(trt), if tag_pharmround==1 & round==1 & medplus==0
}

// NUMBER OF FIRMS
ttest ce_mfirms if round==1 & tag_mktround==1, by(trt)


// PANEL C
use consumer, clear
foreach var in `panel_c'  {
display "`var'"
ttest `var', by(trt), if mp==0 & round==1 & int_loc==2
}





*******************************************************************************
** TABLE 2: TRENDS IN SOCIOECONOMIC STATUS FOR TREATMENT AND CONTROL MARKETS **
*******************************************************************************

use if int_loc==2 using consumer, clear

foreach var in ln_incr_usd edu_years hsize scst tfw {
display "`var'"
reg `var' post if trt==0 & round<3, cl(mkt_id)
reg `var' post if trt==1 & round<3, cl(mkt_id) 
reg `var' post_trt post trt if round<3, cl(mkt_id)
}



foreach var in ln_incr_usd edu_years hsize scst tfw {
display "`var'"
reg `var' post3 if trt==0 & round~=2, cl(mkt_id)
reg `var' post3 if trt==1 & round~=2, cl(mkt_id) 
reg `var' post3_trt post3 trt if round~=2, cl(mkt_id)
}





****************************************************************************
** TABLE 3: CHAIN ENTRY, CUSTOMER TRAFFIC, AND MARKET EXIT FOR INCUMBENTS **
****************************************************************************

use traffic, clear	
areg lntr r2 r2_trt r3 r3_trt                , cl(mkt_id) ab(mkt_id)
areg lntr r2 r2_trt r3 r3_trt $demo_m $hlth_m, cl(mkt_id) ab(mkt_id)
psroutine_3round lntr "$demo_m $hlth_m"

use census, clear
areg present r2 r2_trt r3 r3_trt                , cl(mkt_id) ab(mkt_id)
areg present r2 r2_trt r3 r3_trt $demo_m $hlth_m, cl(mkt_id) ab(mkt_id)
psroutine_3round present "$demo_m $hlth_m"






*****************************************************
** TABLE 4: CHAIN ENTRY AND INCUMBENT DRUG QUALITY **
*****************************************************

use final, clear
areg pass post post_trt,                 cl(mktid) ab(mkt_id), if $urc & ln_ppt~=.
areg pass post post_trt $demo_m $hlth_m, cl(mktid) ab(mkt_id), if $urc & ln_ppt~=.
areg pass post post_trt,                 cl(mktid) ab(mkt_id), if $urc & nn==0 & ln_ppt~=.
areg pass post post_trt $demo_m $hlth_m, cl(mktid) ab(mkt_id), if $urc & nn==0 & ln_ppt~=.
areg pass post post_trt,                 cl(mktid) ab(mkt_id), if $urc & nn==1 & ln_ppt~=.
areg pass post post_trt $demo_m $hlth_m, cl(mktid) ab(mkt_id), if $urc & nn==1 & ln_ppt~=.
areg pass post post_trt $demo_m $hlth_m mk_*, cl(mktid) ab(manuf), if $urc & nn==1 & ln_ppt~=.


****************************************
** PROPORTIONAL SELECTION FOR TABLE 4 **
****************************************

// COLUMN 2
use if $urc & ln_ppt~=. using final, clear
psroutine pass "$demo_m $hlth_m"

// COLUMN 4
use if $urc & nn==0 & ln_ppt~=. using final, clear
psroutine pass "$demo_m $hlth_m"

// COLUMN 6
use if $urc & nn==1 & ln_ppt~=. using final, clear
psroutine pass "$demo_m $hlth_m"











**************************************************
** TABLE 5: THE IMPACT OF CHAIN ENTRY ON PRICES **
**************************************************

use final, clear

areg ln_ppt post post_trt,                 cl(mktid) ab(mkt_id), if $urc
areg ln_ppt post post_trt $demo_m $hlth_m, cl(mktid) ab(mkt_id), if $urc
areg ln_ppt post post_trt,                 cl(mktid) ab(mkt_id), if $urc & nn==0
areg ln_ppt post post_trt $demo_m $hlth_m, cl(mktid) ab(mkt_id), if $urc & nn==0
areg ln_ppt post post_trt,                 cl(mktid) ab(mkt_id), if $urc & nn==1
areg ln_ppt post post_trt $demo_m $hlth_m, cl(mktid) ab(mkt_id), if $urc & nn==1
areg ln_ppt post post_trt $demo_m $hlth_m mk_*, cl(mktid) ab(manuf), if $urc & nn==1


****************************************
** PROPORTIONAL SELECTION FOR TABLE 5 **
****************************************

// COLUMN 2
use if $urc using final, clear
psroutine ln_ppt "$demo_m $hlth_m"

// COLUMN 4
use if $urc & nn==0 using final, clear
psroutine ln_ppt "$demo_m $hlth_m"

// COLUMN 6
use if $urc & nn==1 using final, clear
psroutine ln_ppt "$demo_m $hlth_m"





************************************************
** TABLE 6: CHAIN ENTRY AND PERCEIVED QUALITY **
************************************************

use consumer, clear
areg qual_nearpharms r2 r3 r2_trt r3_trt [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2 & mp==0
areg qual_nearpharms r2 r3 r2_trt r3_trt $demo_m $hlth_m [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2 & mp==0
areg qual_natdrugs   r2 r3 r2_trt r3_trt [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2 & mp==0
areg qual_natdrugs   r2 r3 r2_trt r3_trt $demo_m $hlth_m [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2 & mp==0
areg qual_locdrugs   r2 r3 r2_trt r3_trt [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2 & mp==0
areg qual_locdrugs   r2 r3 r2_trt r3_trt $demo_m $hlth_m [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2 & mp==0

****************************************
** PROPORTIONAL SELECTION FOR TABLE 6 **
****************************************

use if int_loc==2 & mp==0 using consumer, clear

// COLUMN 2
psroutine_3round qual_nearpharms "$demo_m $hlth_m" "[pw=tr_all]"

// COLUMN 4
psroutine_3round qual_natdrugs   "$demo_m $hlth_m" "[pw=tr_all]"

// COLUMN 6
psroutine_3round qual_locdrugs   "$demo_m $hlth_m" "[pw=tr_all]"





****************************************************
** TABLE 7: THE MARKET-WIDE IMPACT OF CHAIN ENTRY **
****************************************************

use final, clear
areg pass post post_trt [pw=tr_all], cl(mktid) ab(mkt_id),   if tag_unitround==1 & ln_ppt~=.
areg pass post post_trt $demo_m $hlth_m  [pw=tr_all], cl(mktid) ab(mkt_id),   if tag_unitround==1 & ln_ppt~=. 
areg pass post pe post_trt post_pe trt_pe post_trt_pe [pw=tr_all], cl(mktid) ab(mktid), if tag_unitround==1 & ln_ppt~=. 
areg pass post he post_trt post_he trt_he post_trt_he [pw=tr_all], cl(mktid) ab(mktid), if tag_unitround==1 & ln_ppt~=. 
areg ln_ppt post post_trt [pw=tr_all], cl(mktid) ab(mkt_id),   if tag_unitround==1
areg ln_ppt post post_trt $demo_m $hlth_m [pw=tr_all], cl(mktid) ab(mkt_id),   if tag_unitround==1
areg ln_ppt post pe post_trt post_pe trt_pe post_trt_pe [pw=tr_all], cl(mktid) ab(mktid), if tag_unitround==1
areg ln_ppt post he post_trt post_he trt_he post_trt_he [pw=tr_all], cl(mktid) ab(mktid), if tag_unitround==1


****************************************
** PROPORTIONAL SELECTION FOR TABLE 7 **
****************************************

use if tag_unitround==1 & ln_ppt~=. using final, clear

psroutine pass   "$demo_m $hlth_m" "[pw=tr_all]" "[pw=tr_all]"
psroutine ln_ppt "$demo_m $hlth_m" "[pw=tr_all]" "[pw=tr_all]"




****************************************************
** TABLE 8: MECHANISMS FOR THE INCUMBENT RESPONSE **
****************************************************

use final, clear

areg national   	  post post_trt, cl(mkt_id) ab(mkt_id), if $urc & tte~=. & mpaspct~=.
areg mpaspct  		  post post_trt, cl(mkt_id) ab(mkt_id), if $urc & tte~=.
areg national_mpaspct post post_trt, cl(mkt_id) ab(mkt_id), if $urc & tte~=.
areg tte			  post post_trt, cl(mkt_id) ab(mkt_id), if $urc & tte~=. & mpaspct~=.
areg degree			  post post_trt, cl(mkt_id) ab(mkt_id), if $prc & ph_include==1
areg ph_workers_tot   post post_trt, cl(mkt_id) ab(mkt_id), if $prc & ph_include==1
areg ph_ac      	  post post_trt, cl(mkt_id) ab(mkt_id), if $prc & ph_include==1
areg ph_shipments 	  post post_trt, cl(mkt_id) ab(mkt_id), if $prc & ph_include==1
areg all_strips	 	  post post_trt, cl(mkt_id) ab(mkt_id), if $prc & ph_include==1







*********************
*********************
**                 **
**    APPENDIX     **
**                 **
*********************
*********************

/*
***************************************************************
** APPENDIX FIGURE 1: THE DISTRIBUTION OF QUALITY COMPONENTS **
***************************************************************

use final, clear

** POOLED API DENSITY
twoway kdensity l_api_pct_cont, bwidth(0.8) scheme(s1color) lcolor(cranberry) xtitle(% of Correct Level) title(Active Ingredient Concentration) ytitle(Kernel Density) xlabel(80[5]115) ylabel(0[0.05].2) lwidth(thick) nodraw, if tag_unitround==1 
graph save kd_api.gph, replace

** POOLED DISSOLUTION
twoway kdensity l_dissol_min, bwidth(1) scheme(s1color) lcolor(cranberry) xtitle(Dissolution) ytitle(Kernel Density) title(Dissolution) nodraw xlabel(30[10]100) ylabel(0[0.05].15) lwidth(thick), if tag_unitround==1 
graph save kd_dissol.gph, replace

** POOLED UNIFORMITY 
twoway kdensity l_uniform_absmax, bwidth(0.3) scheme(s1color) lcolor(cranberry) xtitle(Uniformity) ytitle(Kernel Density) title(Uniformity) nodraw xlabel(0[2]12) /*ylabel(0[0.1].3)*/ lwidth(thick), if tag_unitround==1 
graph save kd_uniform.gph, replace

graph combine kd_api.gph kd_dissol.gph kd_uniform.gph, cols(1) rows(3) title("") scheme(s1color) ysize(11) xsize(5.5)

XXX
*/


/*
***********************************************************************************
** APPENDIX FIGURE 2: EXTREME HEAT AND HUMIDITY DURING DATA COLLECTION, BY ROUND **
***********************************************************************************

use hyd_weather, clear

rename qcptemp temp
rename rhx humidity
drop v5

tostring date, replace
gen yea_s=substr(date,1,4)
gen mon_s=substr(date,5,2)
gen day_s=substr(date,7,2)

destring yea_s, gen(yea)
destring mon_s, gen(mon)
destring day_s, gen(day)

gen date2=mdy(mon,day,yea)
format date2 %td

replace temp=. if temp>41
replace humidity=. if humidity>100

bysort date: egen tempmax=max(temp)
bysort date: egen humimax=max(humidity)
bysort date: egen tempmean=mean(temp)
bysort date: egen humimean=mean(humidity)

bysort date: keep if _n==1
drop temp humidity yea_s mon_s day_s hrmn


gen sample=0
replace sample=1 if yea==2010 & mon==5 & day>=18
replace sample=1 if yea==2010 & mon==6 & day<=19
replace sample=1 if yea==2011 & mon==5 & day>=17
replace sample=1 if yea==2011 & mon==6
replace sample=1 if yea==2011 & mon==7 & day==1


bysort yea: sum humimax tempmax if sample==1
bysort yea: sum humimean tempmean if sample==1

gen dangerous = 0 
replace dangerous = 1 if tempmax > 30 & humimax > 60

sum dangerous if sample==1 & yea==2010
sum dangerous if sample==1 & yea==2011
*/


********************************************************************
** APPENDIX FIGURE 3: THE LOCATION OF SAMPLE MARKETS IN HYDERABAD ** 
********************************************************************


/*
********************************************************************************
** APPENDIX FIGURE 4: QUALITY AND PRICE CHANGES FOR NON-NATIONAL DRUG SAMPLES **
********************************************************************************

use if tag_unitround==1 using final, clear

xtset unit round
set scheme s1mono

xtgraph pass if medplus==0 & nn==1, gr(trt) label 
graph save qual_nn.gph, replace

xtgraph pricepertab_usd if medplus==0 & nn==1, gr(trt) 
graph save price_nn.gph, replace

graph combine qual_nn.gph price_nn.gph, cols(1) rows(2) title("") scheme(s1mono) ysize(11) xsize(7)

XXX
*/






********************************************************
** APPENDIX TABLE 1: THE IMPACT ON QUALITY COMPONENTS **
********************************************************

use final, clear

// PANEL A: ALL MANUFACTURERS
areg l_api post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1 & dosage==500
areg l_api_pct post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1
areg ip_api_pass post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1
areg l_dissol_min post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1
areg ip_dissol_pass post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1
areg l_uniform_absmax post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1
areg ip_uniform_pass post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1

// PANEL B: NON-NATIONAL MANUFACTURERS
areg l_api post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1 & nn==1 & dosage==500
areg l_api_pct post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1 & nn==1
areg ip_api_pass post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1 & nn==1
areg l_dissol_min post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1 & nn==1
areg ip_dissol_pass post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1 & nn==1
areg l_uniform_absmax post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1 & nn==1
areg ip_uniform_pass post post_trt, cl(mktid) ab(mkt_id), if $urc & qq_sample==1 & nn==1




***************************************************
** APPENDIX TABLE 2: ADDITIONAL ROBUSTNESS TESTS **
***************************************************

use final, clear


// PANEL A: DISTANCE TO CENTER
areg pass post post_trt post_dfc,      	cl(mktid) ab(mkt_id), if $urc & ln_ppt~=.
areg pass post post_trt,             	cl(mktid) ab(mkt_id), if $urc & common_dist==1 & ln_ppt~=.
areg pass post post_trt post_dfc,       cl(mktid) ab(mkt_id), if $urc & nn==1 & ln_ppt~=. 
areg pass post post_trt,                cl(mktid) ab(mkt_id), if $urc & nn==1 & common_dist==1 & ln_ppt~=.
areg ln_ppt post post_trt post_dfc,     cl(mktid) ab(mkt_id), if $urc & ln_ppt~=.
areg ln_ppt post post_trt,              cl(mktid) ab(mkt_id), if $urc & common_dist==1 & ln_ppt~=.
areg ln_ppt post post_trt post_dfc,     cl(mktid) ab(mkt_id), if $urc & nn==1 & ln_ppt~=. 
areg ln_ppt post post_trt,              cl(mktid) ab(mkt_id), if $urc & nn==1 & common_dist==1 & ln_ppt~=.


// PANEL B: TRAFFIC GROWTH
areg pass post post_trt post_traff12,   cl(mktid) ab(mkt_id), if $urc & ln_ppt~=.
areg pass post post_trt,                cl(mktid) ab(mkt_id), if $urc & common_traf==1 & ln_ppt~=.
areg pass post post_trt post_traff12,   cl(mktid) ab(mkt_id), if $urc & nn==1 & ln_ppt~=.
areg pass post post_trt,                cl(mktid) ab(mkt_id), if $urc & nn==1 & common_traf==1 & ln_ppt~=.
areg ln_ppt post post_trt post_traff12, cl(mktid) ab(mkt_id), if $urc & ln_ppt~=.
areg ln_ppt post post_trt,              cl(mktid) ab(mkt_id), if $urc & common_traf==1 & ln_ppt~=.
areg ln_ppt post post_trt post_traff12, cl(mktid) ab(mkt_id), if $urc & nn==1  & ln_ppt~=.
areg ln_ppt post post_trt,              cl(mktid) ab(mkt_id), if $urc & nn==1 & common_traf==1 & ln_ppt~=.






****************************************************************
** APPENDIX TABLE 3: ESTIMATES FOR 18 CANDIDATE ENTRY MARKETS **
****************************************************************

use final, clear
areg pass post post_trt,                 	cl(mktid) ab(mkt_id), if $urc & drpm==1 & ln_ppt~=.
areg pass post post_trt $demo_m $hlth_m,  	cl(mktid) ab(mkt_id), if $urc & drpm==1 & ln_ppt~=.
areg pass post post_trt,                 	cl(mktid) ab(mkt_id), if $urc & nn==1 & drpm==1 & ln_ppt~=.
areg pass post post_trt $demo_m $hlth_m, 	cl(mktid) ab(mkt_id), if $urc & nn==1 & drpm==1 & ln_ppt~=.
areg ln_ppt post post_trt,                  cl(mktid) ab(mkt_id), if $urc & drpm==1
areg ln_ppt post post_trt $demo_m $hlth_m,  cl(mktid) ab(mkt_id), if $urc & drpm==1
areg ln_ppt post post_trt,                  cl(mktid) ab(mkt_id), if $urc & nn==1 & drpm==1
areg ln_ppt post post_trt $demo_m $hlth_m,  cl(mktid) ab(mkt_id), if $urc & nn==1 & drpm==1


*************************************************
** PROPORTIONAL SELECTION FOR APPENDIX TABLE 3 **
*************************************************

use if $urc & drpm==1 & ln_ppt~=.         using final, clear
psroutine pass "$demo_m $hlth_m" 

use if $urc & drpm==1 & ln_ppt~=. & nn==1 using final, clear
psroutine pass "$demo_m $hlth_m" 

use if $urc & drpm==1 & ln_ppt~=.         using final, clear
psroutine ln_ppt "$demo_m $hlth_m" 

use if $urc & drpm==1 & ln_ppt~=. & nn==1 using final, clear
psroutine ln_ppt "$demo_m $hlth_m" 







*********************************************************
** APPENDIX TABLE 4: ROBUSTNESS TO UNOBSERVABLE TRENDS ** 
*********************************************************

use final, clear

areg pass post post_trt $demo_bix, cl(mktid) ab(mkt_id), if $urc & nn==1 & ln_ppt~=.
areg pass post post_trt $hlth_bix, cl(mktid) ab(mkt_id), if $urc & nn==1 & ln_ppt~=.
areg pass post post_trt $supp_bix missd post_missd, cl(mktid) ab(mkt_id), if $urc & nn==1 & ln_ppt~=.
areg pass post post_trt pass_phb post_pass_phb, cl(mktid) ab(mkt_id), if $urc & nn==1  & ln_ppt~=.

areg ln_ppt post post_trt $demo_bix, cl(mktid) ab(mkt_id), if $urc & nn==1
areg ln_ppt post post_trt $hlth_bix, cl(mktid) ab(mkt_id), if $urc & nn==1
areg ln_ppt post post_trt $supp_bix missd post_missd, cl(mktid) ab(mkt_id), if $urc & nn==1
areg ln_ppt post post_trt ppt_phb post_ppt_phb, cl(mktid) ab(mkt_id), if $urc & nn==1


*************************************************
** PROPORTIONAL SELECTION FOR APPENDIX TABLE 4 **
*************************************************

use if $urc & nn==1 & ln_ppt~=. using final, clear
psroutine pass "$demo_bix"
psroutine pass "$hlth_bix"
psroutine pass "$supp_bix" "$supp_bix missd post_missd"
psroutine pass "pass_phb post_pass_phb" "pass_phb post_pass_phb"
psroutine ln_ppt "$demo_bix"
psroutine ln_ppt "$hlth_bix"
psroutine ln_ppt "$supp_bix" "$supp_bix missd post_missd"
psroutine ln_ppt "ppt_phb post_ppt_phb" "ppt_phb post_ppt_phb"





****************************************************************************
** APPENDIX TABLE 5: A TEST FOR TREATMENT SPILLOVERS INTO CONTROL MARKETS **
****************************************************************************

use final, clear

areg pass post post_trt,                 cl(mktid) ab(mkt_id), if $urc & csamp==1 & disttrt>=5
areg pass post post_trt,                 cl(mktid) ab(mkt_id), if $urc & csamp==1 & disttrt>=10
areg pass post post_trt,                 cl(mktid) ab(mkt_id), if $urc & csamp==1 & nn==1 & disttrt>=5
areg pass post post_trt,                 cl(mktid) ab(mkt_id), if $urc & csamp==1 & nn==1 & disttrt>=10

areg ln_ppt post post_trt,               cl(mktid) ab(mkt_id), if $urc & csamp==1 & disttrt>=5
areg ln_ppt post post_trt,               cl(mktid) ab(mkt_id), if $urc & csamp==1 & disttrt>=10
areg ln_ppt post post_trt,               cl(mktid) ab(mkt_id), if $urc & csamp==1 & nn==1 & disttrt>=5
areg ln_ppt post post_trt,               cl(mktid) ab(mkt_id), if $urc & csamp==1 & nn==1 & disttrt>=10







*************************************************************************
** APPENDIX TABLE 6: THE IMPACT OF CHAIN ENTRY ON CONSUMER PREFERENCES **
*************************************************************************

use consumer, clear

areg qs r2 r3 r2_trt r3_trt [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2
areg qs r2 r3 r2_trt r3_trt $demo_m $hlth_m [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2

areg cs r2 r3 r2_trt r3_trt [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2
areg cs r2 r3 r2_trt r3_trt $demo_m $hlth_m [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2

areg fs r2 r3 r2_trt r3_trt [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2
areg fs r2 r3 r2_trt r3_trt $demo_m $hlth_m [pw=tr_all], cl(mkt_id) ab(mkt_id), if int_loc==2


*************************************************
** PROPORTIONAL SELECTION FOR APPENDIX TABLE 6 **
*************************************************

use if int_loc==2 using consumer, clear
psroutine_3round qs "$demo_m $hlth_m" "[pw=tr_all]"
psroutine_3round cs "$demo_m $hlth_m" "[pw=tr_all]"
psroutine_3round fs "$demo_m $hlth_m" "[pw=tr_all]"



*************************************************************************
** APPENDIX TABLE 7: CHAIN ENTRY AND INCUMBENT SHOPPER CHARACTERISTICS **
*************************************************************************

use consumer, clear

foreach var in ln_incr_usd edu_years hsize scst tfw {
areg `var' r2 r3 r2_trt r3_trt, cl(mkt_id) ab(mkt_id), if int_loc==1 & mp==0 & dm_sample
}



log close
	
