/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Heterogeneity

INPUTS:
- aff_ds_1.dta
- See .ado files for inputs indirectly used

OUTPUTS:
- Table A-5
- Table A-6
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

global cptchars Survey_Pre_Eval_Time Survey_Pre_Positioning_Time ///
	Survey_Pre_Service_Scrub_Dress_W Survey_Median_Pre_Service_Time ///
	Survey_Median_Intra_Time Survey_Median_Post__ZZZ_XXX_000_ ///
	Survey_Day_of_Proc__090_010_ Survey_Length_of_Hosp_Stay Survey_Median_Post_Time ///
	Survey_Immediate_Post_Time Total_RUC_Survey_Time A99204 A99211 A99212 A99213 ///
	A99214 A99215 A99231 A99232 A99233 A99238 A99239 A99291 A99292 A99296 A99297
	
*** Load data ****************************************************************************
gen_working_data, specwt collapse cptfreq keepvars(${cptchars}) spec_wt_opts(keepall)
gen_var, prervu
proc_pred_vars, jackknife cptterms pos_medbene sor drop ///
	keepvars(lnsurvey_respondents lnsurvey_sample_size ///
	lnsurvey_respondents_avg lnsurvey_sample_size_avg)
merge 1:1 obs_id using data/intermediate/aff_ds_1, assert(match master) ///
	keep(match) nogen

*** Table A-5 ****************************************************************************
foreach var in hi_freq hi_rvu late_mtg {
	capture drop `var'
}
qui sum lncptfreq, d
gen hi_freq=cond(lncptfreq==.,.,lncptfreq>r(p50))
qui sum prervu, d
gen hi_rvu=cond(prervu==.,.,prervu>r(p50))
qui sum lnruc_rec
replace hi_rvu=cond(lnruc_rec==.,.,lnruc_rec>r(p50)) if hi_rvu==.
qui sum mtgid, d
gen late_mtg=mtgid>r(p50)

tab prervu_miss hi_freq
tab prervu_miss hi_rvu
tab hi_freq hi_rvu
/*
. tab prervu_miss hi_freq

prervu_mis |        hi_freq
         s |         0          1 |     Total
-----------+----------------------+----------
         0 |       967      1,394 |     2,361 
         1 |     1,167        740 |     1,907 
-----------+----------------------+----------
     Total |     2,134      2,134 |     4,268 


. tab prervu_miss hi_rvu

prervu_mis |        hi_rvu
         s |         0          1 |     Total
-----------+----------------------+----------
         0 |       180      2,201 |     2,381 
         1 |     2,026          0 |     2,026 
-----------+----------------------+----------
     Total |     2,206      2,201 |     4,407 


. tab hi_freq hi_rvu

           |        hi_rvu
   hi_freq |         0          1 |     Total
-----------+----------------------+----------
         0 |     1,179        955 |     2,134 
         1 |       908      1,226 |     2,134 
-----------+----------------------+----------
     Total |     2,087      2,181 |     4,268 
*/

*** Table A-6 ****************************************************************************
estimates clear
local regline lnprervu prervu_miss lnxb_pos_medbene lnxb_cptchars* *lnruc_rec_xb_sor_jk ///
	lnxb_cptterms
qui foreach hetvar in prervu_miss hi_freq hi_rvu late_mtg {
	capture gen hetvar=`hetvar'
	eststo: reg lnruc_rec i.hetvar#c.naff_1_1_mn hetvar `regline' ///
		i.ruc_yr i.mtg_num specialty_wt*, vce(cluster mtgid)
	sum lnruc_rec if e(sample)
	estadd scalar sample_mean=r(mean)
	drop hetvar
}
esttab, keep(0.hetvar#c.naff_1_1_mn 1.hetvar#c.naff_1_1_mn) ///
	cells(b(fmt(3) star) se(fmt(3) par)) stats(N r2_a sample_mean, fmt(0 3 3)) ///
	starlevels(* .1 ** .05 *** .01)

/*
----------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)   
                lnruc_rec       lnruc_rec       lnruc_rec       lnruc_rec   
                     b/se            b/se            b/se            b/se   
----------------------------------------------------------------------------
0.hetvar#c~n       -0.035           0.169***        0.160***        0.097*  
                  (0.031)         (0.033)         (0.027)         (0.049)   
1.hetvar#c~n        0.209***        0.034          -0.034           0.104***
                  (0.030)         (0.034)         (0.028)         (0.036)   
----------------------------------------------------------------------------
N                    4401            4262            4401            4401   
r2_a                0.896           0.895           0.894           0.891   
sample_mean         1.567           1.595           1.567           1.567   
----------------------------------------------------------------------------
*/	
