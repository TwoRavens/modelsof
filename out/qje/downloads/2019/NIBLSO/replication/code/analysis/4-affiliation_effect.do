/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Affiliation effect

INPUTS:
- aff_ds_1.dta
- cf_proposer_aff.dta
- See .ado files for inputs indirectly used

OUTPUTS:
- Table 3
- Figure 4
- Table A-8
- Figure 6
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
global fullcontrols lnprervu prervu_miss lnxb_cptchars* lnxb_pos_medbene ///
	lnxb_cptterms *lnruc_rec_xb_sor_jk i.ruc_yr i.mtg_num specialty_wt*
	
*** Load data ****************************************************************************
gen_working_data, specwt collapse cptfreq keepvars(${cptchars}) spec_wt_opts(keepall)
gen_var, prervu
proc_pred_vars, jackknife cptterms pos_medbene sor drop ///
	keepvars(lnsurvey_respondents lnsurvey_sample_size ///
	lnsurvey_respondents_avg lnsurvey_sample_size_avg)
merge 1:1 obs_id using data/intermediate/aff_ds_1, assert(match master) ///
	keep(match) nogen

// Merge on expected affiliation by randomly varying proposer identities 
// (see ruc_analyses_102017.do)
capture drop ecf_naff
tempfile master
save `master'
use data/intermediate/cf_proposer_aff, clear
by obs_id: egen ecf_naff=total(cf_naff*wt)
keep obs_id ecf_naff
duplicates drop
merge 1:1 obs_id using `master', assert(matched using) nogen
replace ecf_naff=naff_1_1_mn if ecf_naff==.

*** Table 3 ******************************************************************************
estimates clear
local regline1 lnprervu prervu_miss
local regline2 `regline1' lnxb_pos_medbene
local regline3 `regline2' lnxb_cptchars* *lnruc_rec_xb_sor_jk
local regline4 `regline3' lnxb_cptterms
local regline5 `regline3' ecf_naff
local regline6 `regline4' 

qui foreach num of numlist 1/6 {
	if !inlist(`num',5,6) eststo: reg lnruc_rec naff_1_1_mn `regline`num'' ///
		i.ruc_yr i.mtg_num specialty_wt*, vce(cluster mtgid)
	else if `num'==5 eststo: reg lnruc_rec naff_1_1_mn `regline`num'' ///
		i.ruc_yr i.mtg_num, vce(cluster mtgid)
	else if `num'==6 eststo: reg lnruc_rec naff_1_1_mn `regline`num'' ///
		i.ruc_yr i.mtg_num specialty_wt* c.specialty_wt*#c.ruc_yr, vce(cluster mtgid)	
	sum lnruc_rec if e(sample)
	estadd scalar sample_mean=r(mean)
}
esttab, keep(naff_1_1_mn) cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_a sample_mean, fmt(0 3 3)) starlevels(* .1 ** .05 *** .01)
/*
------------------------------------------------------------------------------------------------------------
                      (1)             (2)             (3)             (4)             (5)             (6)   
                lnruc_rec       lnruc_rec       lnruc_rec       lnruc_rec       lnruc_rec       lnruc_rec   
                     b/se            b/se            b/se            b/se            b/se            b/se   
------------------------------------------------------------------------------------------------------------
naff_1_1_mn         0.158***        0.118***        0.108***        0.101***        0.121*          0.111***
                  (0.027)         (0.023)         (0.033)         (0.029)         (0.065)         (0.033)   
------------------------------------------------------------------------------------------------------------
N                    4401            4401            4401            4401            4401            4401   
r2_a                0.754           0.792           0.889           0.891           0.866           0.897   
sample_mean         1.567           1.567           1.567           1.567           1.567           1.567   
------------------------------------------------------------------------------------------------------------
*/

*** Figure 4 *****************************************************************************
binned_scatter, yvar(lnruc_rec) xvar(naff_1_1_mn) bins(20) cluster(mtgid) ///
	regline(lnprervu prervu_miss lnxb_cptchars* lnxb_pos_medbene ///
	lnxb_cptterms *lnruc_rec_xb_sor_jk i.ruc_yr i.mtg_num specialty_wt*) ///
	graphopts(legend(off) xscale(range(-1.5 1.5)) xlabel(-1(1)1) ///
	name(Figure_4, replace)) xlabel(Affiliation) ylabel(Log RVU) numtype(%9.3f) addN 
assert round(_b[naff_1_1_mn]*10^8)==10069173
graph export "output/Figure_4.eps", as(eps) replace

*** Table A-8 ****************************************************************************
gen lnavg_sample_size=lnsurvey_sample_size-ln(nprops)
gen lnavg_respondents=lnsurvey_respondents-ln(nprops)
		
local regline1 ${fullcontrols} 
local regline2 `regline1' lncptfreq lncptpropfreq
local regline3 `regline2' i.nprops
foreach outcome in sample_size respondents {
estimates clear
qui foreach num of numlist 1/3 { 
	eststo: regress lnavg_`outcome' naff_1_1_mn `regline`num'', vce(cluster mtgid)
	sum lnavg_`outcome' if e(sample)
	estadd scalar sample_mean=r(mean)
}
esttab, keep(naff_1_1_mn) cells(b(fmt(3) star) se(fmt(3) par)) ///
	stats(N r2_a sample_mean, fmt(0 3 3)) starlevels(* .1 ** .05 *** .01)
}
/*
------------------------------------------------------------
                      (1)             (2)             (3)   
             lnavg_samp~e    lnavg_samp~e    lnavg_samp~e   
                     b/se            b/se            b/se   
------------------------------------------------------------
naff_5_2_2~n       -0.228***       -0.332***       -0.146** 
                  (0.071)         (0.076)         (0.070)   
------------------------------------------------------------
N                    4407            4219            4219   
r2_a                0.329           0.332           0.348   
sample_mean         4.660           4.619           4.619   
------------------------------------------------------------

------------------------------------------------------------
                      (1)             (2)             (3)   
             lnavg_resp~s    lnavg_resp~s    lnavg_resp~s   
                     b/se            b/se            b/se   
------------------------------------------------------------
naff_5_2_2~n       -0.219***       -0.413***       -0.082   
                  (0.076)         (0.049)         (0.055)   
------------------------------------------------------------
N                    4407            4219            4219   
r2_a                0.220           0.253           0.304   
sample_mean         3.067           3.071           3.071   
------------------------------------------------------------
*/

*** Figure 6 *****************************************************************************
binned_scatter, yvar(lnavg_sample_size) xvar(naff_1_1_mn) bins(20) ///
	regline(lncptfreq lncptpropfreq ${fullcontrols}) ///
	graphopts(legend(off) name(sample,replace) title(A: Survey Sample, color(black))) ///
	numtype(%9.3f) addN xlabel(Affiliation) ylabel(Log survey sample)
assert round(_b[naff_1_1_mn]*10^6)==-331803
binned_scatter, yvar(lnavg_respondents) xvar(naff_1_1_mn) bins(20) ///
	regline(lncptfreq lncptpropfreq ${fullcontrols}) ///
	graphopts(legend(off) name(respondents,replace) title(B: Respondents, color(black))) ///
	numtype(%9.3f) addN xlabel(Affiliation) ylabel(Log respondents)
assert round(_b[naff_1_1_mn]*10^6)==-413360
graph combine sample respondents, ysize(6) xsize(4) cols(1) iscale(*1.1) ///
	graphregion(color(white)) name(Figure_6, replace)
graph export "output/Figure_6.eps", as(eps) replace
