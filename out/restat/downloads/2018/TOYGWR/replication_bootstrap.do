


cap log close
log using replication_bootstrap.log, replace
set more off

*** IMPLEMENTS WILD CLUSTER BOOTSTRAP P-VALUES FOR "THE MARKET FOR HIGH QUALITY MEDICINE"
*** DANIEL BENNETT AND WESLEY YIN
*** FEBRUARY 2018


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


****************************
** WILD CLUSTER BOOTSTRAP **
****************************

** PROGRAM COMPUTES THE P-VALUE FOR ONE REGRESSOR USING THE WILD CLUSTER BOOTSTRAP (CAMERON, GELBACH, AND MILLER 2008 RESTAT).
** SPECIFY FIXED EFFECTS AS DUMMY VARIABLES

** INPUTS ARE: 
** 1: DEPENDENT VARIABLE
** 2: REGRESSOR OF INTEREST
** 3: OTHER REGRESSORS IN THE MODEL (INLCUDING FIXED EFFECTS)
** 4: LIMITS ON THE REGRESSION SAMPLE (STUFF FOLLOWING THE "IF")
** 5: NUMBER OF BOOTSTRAP REPLICATIONS


capture program drop wildbs
program define wildbs
set seed 19800426

tempfile main bootsave
use $indata, clear
qui reg `1' `2' `3' if `4', cl(mkt_id) 
global maint=_b[`2']/_se[`2']

qui reg `1' `3' if `4', cl(mkt_id)
predict epshat, resid
predict yhat, xb
sort mkt_id
qui save bsfile, replace

postfile bskeep t_wild using bs_results, replace

forvalues b=1/`5' {
use bsfile, replace
qui by mkt_id: gen temp=uniform()
qui by mkt_id: gen pos=(temp[1]<0.5)
qui gen wildresid=epshat*(2*pos-1)
qui gen wildy=yhat+wildresid
qui reg wildy `2' `3' if `4', cl(mkt_id)
local bst_wild=_b[`2']/_se[`2']
post bskeep(`bst_wild')
}
postclose bskeep

clear
use bs_results
gen positive=($maint>0)
gen pos=(t_wild>$maint)
gen neg=(t_wild<$maint)
gen reject=positive*pos+(1-positive)*neg
qui sum reject
local sumreject=r(sum)
local p_value_wild=2*`sumreject'/`5'
local p_value_main=2*(ttail((19),abs($maint)))

display "Number BS reps = `5'"
display "P-value from clustered standard errors = `p_value_main'"
display "P-value from wild bootstrap = `p_value_wild'"
end




****************************************
** SPECIFY THE NUMBER OF REPLICATIONS **
****************************************

global breps=20
global indata "final"





*************
** TABLE 3 **
*************

*(1) 
global indata traffic
wildbs lntr r2_trt "r2 r3 r3_trt mk_*" "_n>0" $breps
wildbs lntr r3_trt "r2 r3 r2_trt mk_*" "_n>0" $breps

*(2)
wildbs lntr r2_trt "r2 r3 r3_trt mk_* $demo_m $hlth_m" "_n>0" $breps
wildbs lntr r3_trt "r2 r3 r2_trt mk_* $demo_m $hlth_m" "_n>0" $breps

*(3)
global indata census
wildbs present r2_trt "r2 r3 r3_trt mk_*" "_n>0" $breps
wildbs present r3_trt "r2 r3 r2_trt mk_*" "_n>0" $breps

*(4)
wildbs present r2_trt "r2 r3 r3_trt mk_* $demo_m $hlth_m" "_n>0" $breps
wildbs present r3_trt "r2 r3 r2_trt mk_* $demo_m $hlth_m" "_n>0" $breps





*************
** TABLE 4 **
*************

global indata final

*(1)
wildbs pass post_trt "post mk_*" "$urc & ln_ppt~=." $breps

*(2)
wildbs pass post_trt "post mk_* $demo_m $hlth_m" "$urc & ln_ppt~=." $breps

*(3)
wildbs pass post_trt "post mk_*" "$urc & nn==0 & ln_ppt~=." $breps

*(4)
wildbs pass post_trt "post mk_* $demo_m $hlth_m" "$urc & nn==0 & ln_ppt~=." $breps

*(5)
wildbs pass post_trt "post mk_*" "$urc & nn==1 & ln_ppt~=." $breps

*(6)
wildbs pass post_trt "post mk_* $demo_m $htlh_m" "$urc & nn==1 & ln_ppt~=." $breps

*(7)
wildbs pass post_trt "post mk_* man_* $demo_m $htlh_m" "$urc & nn==1 & ln_ppt~=." $breps




*************
** TABLE 5 **
*************

*(1)
global indata final
wildbs ln_ppt post_trt "post mk_*" "$urc" $breps

*(2)
wildbs ln_ppt post_trt "post mk_* $demo_m $hlth_m" "$urc" $breps

*(3)
wildbs ln_ppt post_trt "post mk_*" "$urc & nn==0" $breps

*(4)
wildbs ln_ppt post_trt "post mk_* $demo_m $hlth_m" "$urc & nn==0" $breps

*(5)
wildbs ln_ppt post_trt "post mk_*" "$urc & nn==1" $breps

*(6)
wildbs ln_ppt post_trt "post mk_* $demo_m $hlth_m" "$urc & nn==1" $breps

*(7)
wildbs ln_ppt post_trt "post mk_* $demo_m $hlth_m man_*" "$urc & nn==1" $breps








*************
** TABLE 6 **
*************

*(1)
global indata consumer
wildbs qual_nearpharms r2_trt "r2 r3 r3_trt mk_* [pw=tr_all]" "int_loc==2 & mp==0" $breps
wildbs qual_nearpharms r3_trt "r2 r3 r2_trt mk_* [pw=tr_all]" "int_loc==2 & mp==0" $breps

*(2)
wildbs qual_nearpharms r2_trt "r2 r3 r3_trt mk_* $demo_m $hlth_m [pw=tr_all]" "int_loc==2 & mp==0" $breps
wildbs qual_nearpharms r3_trt "r2 r3 r2_trt mk_* $demo_m $hlth_m [pw=tr_all]" "int_loc==2 & mp==0" $breps

*(3)
wildbs qual_natdrugs r2_trt "r2 r3 r3_trt mk_* [pw=tr_all]" "int_loc==2 & mp==0" $breps
wildbs qual_natdrugs r3_trt "r2 r3 r2_trt mk_* [pw=tr_all]" "int_loc==2 & mp==0" $breps

*(4)
wildbs qual_natdrugs r2_trt "r2 r3 r3_trt mk_* $demo_m $hlth_m [pw=tr_all]" "int_loc==2 & mp==0" $breps
wildbs qual_natdrugs r3_trt "r2 r3 r2_trt mk_* $demo_m $hlth_m [pw=tr_all]" "int_loc==2 & mp==0" $breps

*(5)
wildbs qual_locdrugs r2_trt "r2 r3 r3_trt mk_* [pw=tr_all]" "int_loc==2 & mp==0" $breps
wildbs qual_locdrugs r3_trt "r2 r3 r2_trt mk_* [pw=tr_all]" "int_loc==2 & mp==0" $breps

*(6)
wildbs qual_locdrugs r2_trt "r2 r3 r3_trt mk_* $demo_m $hlth_m [pw=tr_all]" "int_loc==2 & mp==0" $breps
wildbs qual_locdrugs r3_trt "r2 r3 r2_trt mk_* $demo_m $hlth_m [pw=tr_all]" "int_loc==2 & mp==0" $breps






*************
** TABLE 7 **
*************

*(1)
global indata final
wildbs pass post_trt "post mk_* [pw=tr_all]" "tag_unitround==1 & ln_ppt~=." $breps

*(2)
wildbs pass post_trt "post mk_* $demo_m $hlth_m [pw=tr_all]" "tag_unitround==1 & ln_ppt~=." $breps

*(3)
wildbs pass post_trt "post mk_* pe post_pe trt_pe post_trt_pe [pw=tr_all]" "tag_unitround==1 & ln_ppt~=." $breps
wildbs pass post_trt_pe "post mk_* pe post_pe trt_pe post_trt [pw=tr_all]" "tag_unitround==1 & ln_ppt~=." $breps

*(4)
wildbs pass post_trt "post mk_* he post_he trt_he post_trt_he [pw=tr_all]" "tag_unitround==1 & ln_ppt~=." $breps
wildbs pass post_trt_he "post mk_* he post_he trt_he post_trt [pw=tr_all]" "tag_unitround==1 & ln_ppt~=." $breps

*(5)
wildbs ln_ppt post_trt "post mk_* [pw=tr_all]" "tag_unitround==1" $breps

*(6)
wildbs ln_ppt post_trt "post mk_* $demo_m $hlth_m [pw=tr_all]" "tag_unitround==1" $breps

*(7)
wildbs ln_ppt post_trt "post mk_* pe post_pe trt_pe post_trt_pe [pw=tr_all]" "tag_unitround==1" $breps
wildbs ln_ppt post_trt_pe "post mk_* pe post_pe trt_pe post_trt [pw=tr_all]" "tag_unitround==1" $breps

*(8)
wildbs ln_ppt post_trt "post mk_* he post_he trt_he post_trt_he [pw=tr_all]" "tag_unitround==1" $breps
wildbs ln_ppt post_trt_he "post mk_* he post_he trt_he post_trt [pw=tr_all]" "tag_unitround==1" $breps





*************
** TABLE 8 **
*************

*(1)
global indata final
wildbs national         post_trt "post mk_*" "$urc & tte~=. & mpaspct~=." $breps

*(2)
wildbs mpaspct          post_trt "post mk_*" "$urc & tte~=." $breps

*(3)
wildbs national_mpaspct post_trt "post mk_*" "$urc & tte~=." $breps

*(4)
wildbs tte              post_trt "post mk_*" "$urc & tte~=. & mpaspct~=." $breps

*(5)
wildbs degree           post_trt "post mk_*" "$prc & ph_include==1" $breps

*(6)
wildbs ph_workers_tot   post_trt "post mk_*" "$prc & ph_include==1" $breps

*(7)
wildbs ph_ac            post_trt "post mk_*" "$prc & ph_include==1" $breps

*(8)
wildbs ph_shipments     post_trt "post mk_*" "$prc & ph_include==1" $breps

*(9)
wildbs all_strips       post_trt "post mk_*" "$prc & ph_include==1" $breps







**********************
** APPENDIX TABLE 1 **
**********************

// PANEL A
*(1)
global indata final
wildbs l_api post "post_trt mk_*" "$urc & qq_sample==1 & dosage==500" $breps
wildbs l_api post_trt "post mk_*" "$urc & qq_sample==1 & dosage==500" $breps

*(2)
wildbs l_api_pct post "post_trt mk_*" "$urc & qq_sample==1" $breps
wildbs l_api_pct post_trt "post mk_*" "$urc & qq_sample==1" $breps

*(3)
wildbs ip_api_pass post "post_trt mk_*" "$urc & qq_sample==1" $breps
wildbs ip_api_pass post_trt "post mk_*" "$urc & qq_sample==1" $breps

*(4)
wildbs l_dissol_min post "post_trt mk_*" "$urc & qq_sample==1" $breps
wildbs l_dissol_min post_trt "post mk_*" "$urc & qq_sample==1" $breps

*(5)
wildbs ip_dissol_pass post "post_trt mk_*" "$urc & qq_sample==1" $breps
wildbs ip_dissol_pass post_trt "post mk_*" "$urc & qq_sample==1" $breps

*(6)
wildbs l_uniform_absmax post "post_trt mk_*" "$urc & qq_sample==1" $breps
wildbs l_uniform_absmax post_trt "post mk_*" "$urc & qq_sample==1" $breps

*(7)
wildbs ip_uniform_pass post "post_trt mk_*" "$urc & qq_sample==1" $breps
wildbs ip_uniform_pass post_trt "post mk_*" "$urc & qq_sample==1" $breps



// PANEL B
*(1)
wildbs l_api post "post_trt mk_*" "$urc & qq_sample==1 & dosage==500 & nn==1" $breps
wildbs l_api post_trt "post mk_*" "$urc & qq_sample==1 & dosage==500 & nn==1" $breps

*(2)
wildbs l_api_pct post "post_trt mk_*" "$urc & qq_sample==1 & nn==1" $breps
wildbs l_api_pct post_trt "post mk_*" "$urc & qq_sample==1 & nn==1" $breps

*(3)
wildbs ip_api_pass post "post_trt mk_*" "$urc & qq_sample==1 & nn==1" $breps
wildbs ip_api_pass post_trt "post mk_*" "$urc & qq_sample==1 & nn==1" $breps

*(4)
wildbs l_dissol_min post "post_trt mk_*" "$urc & qq_sample==1 & nn==1" $breps
wildbs l_dissol_min post_trt "post mk_*" "$urc & qq_sample==1 & nn==1" $breps

*(5)
wildbs ip_dissol_pass post "post_trt mk_*" "$urc & qq_sample==1 & nn==1" $breps
wildbs ip_dissol_pass post_trt "post mk_*" "$urc & qq_sample==1 & nn==1" $breps

*(6)
wildbs l_uniform_absmax post "post_trt mk_*" "$urc & qq_sample==1 & nn==1" $breps
wildbs l_uniform_absmax post_trt "post mk_*" "$urc & qq_sample==1 & nn==1" $breps

*(7)
wildbs ip_uniform_pass post "post_trt mk_*" "$urc & qq_sample==1 & nn==1" $breps
wildbs ip_uniform_pass post_trt "post mk_*" "$urc & qq_sample==1 & nn==1" $breps






**********************
** APPENDIX TABLE 3 **
**********************

*(1)
global indata final
wildbs pass post_trt "post mk_*" "$urc & drpm==1 & ln_ppt~=." $breps

*(2)
wildbs pass post_trt "post mk_* $demo_m $hlth_m" "$urc & drpm==1 & ln_ppt~=." $breps

*(3)
wildbs pass post_trt "post mk_*" "$urc & nn==1 & drpm==1 & ln_ppt~=." $breps

*(4)
wildbs pass post_trt "post mk_* $demo_m $hlth_m" "$urc & nn==1 & drpm==1 & ln_ppt~=." $breps

*(5)
wildbs ln_ppt post_trt "post mk_*" "$urc & drpm==1 & ln_ppt~=." $breps

*(6)
wildbs ln_ppt post_trt "post mk_* $demo_m $hlth_m" "$urc & drpm==1 & ln_ppt~=." $breps

*(7)
wildbs ln_ppt post_trt "post mk_*" "$urc & nn==1 & drpm==1& ln_ppt~=." $breps

*(8)
wildbs ln_ppt post_trt "post mk_* $demo_m $hlth_m" "$urc & nn==1 & drpm==1 & ln_ppt~=." $breps




**********************
** APPENDIX TABLE 4 **
**********************

*(1)
global indata final
wildbs pass post_trt "post $demo_bix mk_*" "$urc & nn==1" $breps

*(2)
wildbs pass post_trt "post $hlth_bix mk_*" "$urc & nn==1" $breps

*(3)
wildbs pass post_trt "post $supp_bix mk_*" "$urc & nn==1" $breps

*(4)
wildbs pass post_trt "post pass_phb post_pass_phb mk_*" "$urc & nn==1" $breps

*(5)
wildbs ln_ppt post_trt "post $demo_bix mk_*" "$urc & nn==1" $breps

*(6)
wildbs ln_ppt post_trt "post $hlth_bix mk_*" "$urc & nn==1" $breps

*(7)
wildbs ln_ppt post_trt "post $supp_bix mk_*" "$urc & nn==1" $breps

*(8)
wildbs ln_ppt post_trt "post ppt_phb post_ppt_phb mk_*" "$urc & nn==1" $breps





**********************
** APPENDIX TABLE 5 **
**********************

*(1)
global indata final
wildbs pass post_trt "post mk_*" "$urc & qq_sample==1 & disttrt>=5" $breps

*(2)
wildbs pass post_trt "post mk_*" "$urc & qq_sample==1 & disttrt>=10" $breps

*(3)
wildbs pass post_trt "post mk_*" "$urc & qq_sample==1 & disttrt>=5 & nn==1" $breps

*(4)
wildbs pass post_trt "post mk_*" "$urc & qq_sample==1 & disttrt>=10 & nn==1" $breps

*(5)
wildbs ln_ppt post_trt "post mk_*" "$urc & qq_sample==1 & disttrt>=5" $breps

*(6)
wildbs ln_ppt post_trt "post mk_*" "$urc & qq_sample==1 & disttrt>=10" $breps

*(7)
wildbs ln_ppt post_trt "post mk_*" "$urc & qq_sample==1 & disttrt>=5 & nn==1" $breps

*(8)
wildbs ln_ppt post_trt "post mk_*" "$urc & qq_sample==1 & disttrt>=10 & nn==1" $breps




**********************
** APPENDIX TABLE 6 **
**********************

*(1)
global indata consumer
wildbs qs r2_trt "r2 r3 r3_trt mk_* [pw=tr_all]" "int_loc==2" $breps
wildbs qs r3_trt "r2 r3 r2_trt mk_* [pw=tr_all]" "int_loc==2" $breps

*(2)
wildbs qs r2_trt "r2 r3 r3_trt $demo_m $hlth_m mk_* [pw=tr_all]" "int_loc==2" $breps
wildbs qs r3_trt "r2 r3 r2_trt $demo_m $hlth_m mk_* [pw=tr_all]" "int_loc==2" $breps

*(3)
wildbs cs r2_trt "r2 r3 r3_trt mk_* [pw=tr_all]" "int_loc==2" $breps
wildbs cs r3_trt "r2 r3 r2_trt mk_* [pw=tr_all]" "int_loc==2" $breps

*(4)
wildbs cs r2_trt "r2 r3 r3_trt $demo_m $hlth_m mk_* [pw=tr_all]" "int_loc==2" $breps
wildbs cs r3_trt "r2 r3 r2_trt $demo_m $hlth_m mk_* [pw=tr_all]" "int_loc==2" $breps

*(5)
wildbs fs r2_trt "r2 r3 r3_trt mk_* [pw=tr_all]" "int_loc==2" $breps
wildbs fs r3_trt "r2 r3 r2_trt mk_* [pw=tr_all]" "int_loc==2" $breps

*(6)
wildbs fs r2_trt "r2 r3 r3_trt $demo_m $hlth_m mk_* [pw=tr_all]" "int_loc==2" $breps
wildbs fs r3_trt "r2 r3 r2_trt $demo_m $hlth_m mk_* [pw=tr_all]" "int_loc==2" $breps






**********************
** APPENDIX TABLE 7 **
**********************

*(1)
global indata consumer
wildbs ln_incr_usd r2_trt "r2 r3 r3_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps
wildbs ln_incr_usd r3_trt "r2 r3 r2_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps

*(2)
wildbs edu_years r2_trt "r2 r3 r3_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps
wildbs edu_years r3_trt "r2 r3 r2_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps

*(3)
wildbs hsize r2_trt "r2 r3 r3_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps
wildbs hsize r3_trt "r2 r3 r2_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps

*(4)
wildbs scst r2_trt "r2 r3 r3_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps
wildbs scst r3_trt "r2 r3 r2_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps

*(5)
wildbs tfw r2_trt "r2 r3 r3_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps
wildbs tfw r3_trt "r2 r3 r2_trt mk_*" "int_loc==1 & mp==0 & dm_sample==1" $breps


log close
	
