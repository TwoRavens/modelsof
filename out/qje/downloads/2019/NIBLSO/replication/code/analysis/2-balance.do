/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Balance

INPUTS:
- medicare_bene.dta
- rucdate_mtg_xwalk.dta
- specialty_specid_xwalk.dta
- See .ado files for inputs indirectly used

OUTPUTS:
- Table 2
- Figure A-3
- Figure A-4
- Figure A-5
- Figure A-6
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

*** Table 2 ******************************************************************************
// Load data
gen_working_data, specwt aff collapse cptfreq keepvars(${cptchars})
proc_pred_vars, jackknife cptterms
gen_var, pos medbene prervu

// Predicted RVU recommendation based on Medicare beneficiary characteristics
reg lnruc_rec pct_*
disp e(r2) // .24878085
capture drop lnxb_medbene
predict lnxb_medbene

// State balance in terms of t-test
sum aff
gen byte hi_aff=cond(aff==.,.,aff>r(mean))
qui reg aff i.mtgid specialty_wt* if !medbene_m	
predict aff_resid if !medbene_m, resid
sum aff_resid
gen byte hi_aff_resid=cond(aff_resid==.,.,aff_resid>r(mean))
capture drop pct_* medbene_m
merge m:1 cpt_code using "data/raw/medicare_bene", keep(master match)
gen medbene_m=_merge!=3
drop _merge
local hivar hi_aff
qui foreach var of varlist pct_* {
	capture drop *`var'_resid 
	sum `var' if !medbene_m
	scalar mean=`r(mean)'
	reg `var' i.mtgid specialty_wt* if !medbene_m	
	predict `var'_resid if !medbene_m, resid
	replace `var'_resid=`var'_resid+scalar(mean)
	ttest `var'_resid if !medbene_m&`var'_resid!=., by(hi_aff_resid) unequal
	foreach obj in mu_1 mu_2 sd_1 sd_2 {
		local `obj' `=string(r(`obj'),"%9.3f")'
	}
	if "`hivar'"=="hi_aff" {
		reg `var' hi_aff i.mtgid specialty_wt* if !medbene_m, vce(cluster mtgid)
		local p=(2 * ttail(e(df_r), abs(_b[hi_aff]/_se[hi_aff])))
	}
	else if "`hivar'"=="hi_aff_resid" {
		reg `var'_resid hi_aff_resid, vce(cluster mtgid)
		local p=(2 * ttail(e(df_r), abs(_b[hi_aff_resid]/_se[hi_aff_resid])))
	}
	local p `=string(`p',"%9.3f")'
	noi disp as text "`var': " as result _col(25) "`mu_1'" _col(33) "(`sd_1')" ///
		_col(45) "`mu_2'" _col(53) "(`sd_2')" _col(65) "p = `p'"
	drop `var'_resid
}
/*
pct_male:               0.471   (0.107)     0.470   (0.101)     p = 0.371
pct_female:             0.529   (0.107)     0.530   (0.101)     p = 0.371
pct_rural:              0.206   (0.052)     0.208   (0.054)     p = 0.784
pct_urban:              0.794   (0.052)     0.792   (0.054)     p = 0.784
pct_age_over_75:        0.405   (0.109)     0.416   (0.106)     p = 0.366
pct_over_85:            0.131   (0.067)     0.135   (0.067)     p = 0.745
pct_Medicare_aged:      0.767   (0.126)     0.782   (0.108)     p = 0.463
pct_Medcare_disabled:   0.155   (0.062)     0.147   (0.058)     p = 0.426
pct_Medicare_ESRD:      0.063   (0.114)     0.054   (0.079)     p = 0.903
pct_Race_White:         0.828   (0.077)     0.837   (0.074)     p = 0.148
pct_Race_Black:         0.111   (0.059)     0.105   (0.052)     p = 0.989
pct_Race_Hispanic:      0.025   (0.012)     0.024   (0.013)     p = 0.109
pct_Race_Other:         0.038   (0.015)     0.036   (0.015)     p = 0.018
pct_DGNS_1:             0.532   (0.196)     0.540   (0.202)     p = 0.275
pct_DGNS_2:             0.165   (0.078)     0.158   (0.080)     p = 0.010
pct_DGNS_3:             0.089   (0.043)     0.084   (0.042)     p = 0.055
pct_DGNS_4:             0.057   (0.027)     0.055   (0.028)     p = 0.277
pct_DGNS_5:             0.039   (0.020)     0.039   (0.020)     p = 0.580
*/	

count if !medbene_m&hi_aff==1
count if !medbene_m&hi_aff==0
/*
. count if !medbene_m&hi_aff==1
  3,046

. count if !medbene_m&hi_aff==0
  1,256
*/

*** Figure A-3 ***************************************************************************
sum aff
gen naff=aff/r(sd)
binned_scatter if !medbene, yvar(lnxb_medbene) xvar(naff) bins(20) addN ///
	ylabel(Predicted log RVU) xlabel(Affiliation) regline(specialty_wt* i.mtgid) /// 
	graphopts(legend(off) ylabel(-.2(.1).2) xlabel(-1(1)1) name(Figure_A3, replace)) ///
	numtype(%9.3f) 
graph export "output/Figure_A-3.eps", as(eps) replace

*** Figure A-4 ***************************************************************************
// Generate pseudo-meetings, with pseudo-affiliations
gen_working_data
gen_specialty
drop if specialty==""
tempfile ri mtgid_xwalk
preserve
use ${xwalkdir}/rucdate_mtg_xwalk, clear
keep ruc_yr mtg_num mtgid ruc_cycle
duplicates drop
save `mtgid_xwalk', replace
restore
levelsof mtgid, local(levels)
rename mtgid true_mtgid
rename ruc_cycle true_ruc_cycle
drop rucdate ruc_yr mtg_num
qui foreach mtgid of numlist `levels' {
	if `mtgid'==1 noi disp as text "Meeting ID: " _c
	noi disp as text `mtgid' " " _c
	preserve
	gen mtgid=`mtgid'
	merge m:1 mtgid using `mtgid_xwalk', keep(match) nogen
	gen_aff, moments(mean) long
	keep cpt_code obs_id mtgid aff* true_mtgid ruc_yr mtg_num ruc_cycle ///
		true_ruc_cycle
	if mtgid>1 append using `ri'
	save `ri', replace
	restore
}

// Plot counterfactual relative to actual affiliations
gen_working_data, specwt collapse spec_wt_opts(keepall)
keep obs_id specialty_wt*
isid obs_id
merge 1:m obs_id using `ri', keep(match) assert(match master) nogen
by obs_id, sort: egen true_aff=min(cond(true_mtgid==mtgid,aff,.))
by obs_id: gen byte true_obs=true_mtgid==mtgid
by obs_id: gen byte obs1=_n==1
sum true_aff if obs1
scalar sd_aff=r(sd)
gen diff_aff=(true_aff-aff)/sd_aff
qui foreach sample in A B {
	preserve
	if "`sample'"=="A" {
		local title A: All Meetings
	}
	else {
		local title B: Adjacent Meetings
		keep if abs(true_mtgid-mtgid)<=3
	}
	reg diff_aff, vce(cluster mtgid)
	scalar mean_diff_aff=_b[_cons]
	scalar se_diff_aff=_se[_cons]
	scalar lcl=mean_diff_aff-1.96*se_diff_aff
	scalar ucl=mean_diff_aff+1.96*se_diff_aff
	twoway (kdensity diff_aff if abs(diff_aff)<.4, lcolor(gs8)), ///
		xtitle(Pseudo-affiliation difference) ytitle(Density) title(`title', color(black)) ///
		xline(`=mean_diff_aff', lpattern(solid) lcolor(gs8)) ///
		xline(`=lcl' `=ucl', lpattern(dash) lcolor(gs8)) ///
		xlabel(-.4(.2).4) graphregion(color(white)) ylabel(, nogrid) name(`sample', replace)
	noi disp as text "Sample `sample': Mean = " as result mean_diff_aff as text ///
		", (LCL, UCL) = (" as result lcl as text ", " as result ucl as text ")"
	gen naff=aff/sd_aff
	by obs_id, sort: egen mean_naff=mean(naff)
	gen r_naff=naff-mean_naff
	sum r_naff
	scalar var_r_naff=r(sd)^2
	keep mean_naff obs_id specialty_wt*
	duplicates drop
	isid obs_id
	reg mean_naff specialty_wt*
	predict r_mean_naff, resid
	sum r_mean_naff
	scalar var_r_mean_naff=r(sd)^2
	noi disp as text "          Var_t =" as result ///
		`=var_r_naff' as text ", Var_i = " as result `=var_r_mean_naff' _c
	noi disp as text "; Var_t / (Var_t + Var_i) = " as result ///
		`=var_r_naff/(var_r_mean_naff+var_r_naff)'
	if "`sample'"=="A" {
		assert round(mean_diff_aff*10^8)==235638&round(ucl*10^8)==1726864
		assert round(var_r_naff*10^8)==533952
	}
	else {
		assert round(mean_diff_aff*10^8)==-87471&round(ucl*10^8)==812492
		assert round(var_r_naff*10^8)==245566
	}
	restore
}
graph combine A B, ysize(6) xsize(4) cols(1) iscale(*1.1) graphregion(color(white)) ///
	name(Figure_A4, replace)
graph export "output/Figure_A-4.eps", as(eps) replace
/*
Sample A: Mean = .00235638, (LCL, UCL) = (-.01255588, .01726864)
          Var_t =.00533952, Var_i = .36348797; Var_t / (Var_t + Var_i) = .014477
Sample B: Mean = -.00087471, (LCL, UCL) = (-.00987434, .00812492)
          Var_t =.00245566, Var_i = .36114727; Var_t / (Var_t + Var_i) = .0067537
*/

*** Data for Figures A-5 and A-6 *********************************************************
gen_working_data, specwt
drop survey_specialty
merge m:1 specialty using "${spec_linking_dir}/specialty_specid_xwalk", ///
	keep(match) nogen
tempfile master
save `master', replace
gen_working_data, keepvars(${cptchars})
gen_specialty
gen_var, prervu
proc_pred_vars, jackknife cptterms drop
keep obs_id specialty lnxb_cptchars lnxb_survey lnxb_cptterms lnprervu
merge m:1 specialty using "${spec_linking_dir}/specialty_specid_xwalk", ///
	keep(match) nogen
preserve
tempfile valid_obs_id
keep obs_id
duplicates drop
save `valid_obs_id'
restore
merge 1:1 obs_id specid using `master'
drop if _merge==1
gen byte inprop=_merge==3
drop _merge
merge m:1 obs_id using `valid_obs_id', keep(match) nogen
foreach var of varlist lnxb_cptchars lnxb_survey lnxb_cptterms lnprervu {
	rename `var' temp 
	by obs_id, sort: egen `var'=min(temp)
	drop temp
}

*** Calculate propensity *****************************************************************
preserve
by obs_id, sort: egen maxwt=max(specialty_wt)
by obs_id: gen byte maxshare=specialty_wt==maxwt
gen byte zerowt=specialty_wt==0
gen byte vlowwt=specialty_wt<.03
gen lnwt=cond(zerowt,0,ln(specialty_wt))
mkspline lnwt_sp=lnwt if !zerowt, cubic nknots(3)
replace lnwt_sp1=0 if zerowt
replace lnwt_sp2=0 if zerowt

qui logit inprop maxshare lnwt_sp? zerowt vlowwt maxwt i.specid // R2 .6744
predict pr_inprop, pr
drop if pr_inprop==.
tempfile pr_inprop
save `pr_inprop', replace
restore

*** Figure A-5 ***************************************************************************
qui reg lnruc_rec lnxb_cptchars lnxb_survey lnxb_cptterms lnprervu
predict grandxb, xb // R2 0.880
gen byte zerowt=specialty_wt==0

binned_scatter, yvar(inprop) xvar(grandxb) regline(i.specid specialty_wt zerowt ///
	i.mtgid) bins(20) graphopts(ylabel(-.15(.05).15) legend(off) ///
	name(Figure_A5, replace)) ylabel(Pr(propose)) ///
	xlabel(Predicted log RVU) addN cluster(mtgid) numtype(%9.4f)
assert e(N)==271552&round(_b[grandxb]*10^8)==-30606
graph export "output/Figure_A-5.eps", as(eps) replace

*** Figure A-6 ***************************************************************************
tempfile master props
gen_working_data, aff collapse
keep obs_id cpt_code ruc_yr mtg_num mtgid survey_specialty rucdate
save `props'
gen_specialty
drop rucdate orig_specmissing nprops
// 3 specialties do not exist in Medicare data and rarely propose
drop if inlist(specialty,"Chiropractic","Medical Genetics","Transplant Surgery") 
save `master'
keep specialty
duplicates drop
levelsof specialty, local(levels)

use `props', clear
isid obs_id
tempfile ri
qui foreach specialty in `levels' {
	noi disp as text "`specialty' " _c
	preserve
	gen specialty="`specialty'"
	gen_aff, moments(mean) long	
	gen specialty="`specialty'"
	capture append using `ri'
	save `ri', replace
	restore
}
use `ri', clear
merge 1:1 obs_id specialty using `master', assert(master match) 
gen byte true_spec=_merge==3
by obs_id, sort: egen hasmatch=max(true_spec)
keep if hasmatch
merge m:1 specialty using "${spec_linking_dir}/specialty_specid_xwalk", keep(match) nogen
drop _merge survey_specialty specialty hasmatch

merge 1:1 obs_id specid using `pr_inprop', keep(master match) nogen
gen pr_inprop_m=pr_inprop==.
replace pr_inprop=0 if pr_inprop==.
by obs_id, sort: egen nprops=total(true_spec)
sum aff
gen naff=(aff-r(mean))/r(sd)
by specid, sort: egen mean_aff=mean(aff)
gen aff_r=aff-mean_aff
sum aff_r
gen naff_r=(aff_r-r(mean))/r(sd)

binned_scatter, yvar(inprop) xvar(naff_r) regline(i.nprops i.specid) ///
	bins(20) graphopts(ylabel(-.15(.05).15) legend(off) name(Figure_A6, replace)) ///
	ylabel(Pr(propose)) xlabel(Affiliation) addN cluster(mtgid) numtype(%9.4f)
assert round(_b[naff_r]*10^8)==43196
graph export "output/Figure_A-6.eps", as(eps) replace
