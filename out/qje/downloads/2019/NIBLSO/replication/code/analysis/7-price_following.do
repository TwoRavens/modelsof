/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Price-following analyses

INPUTS:
- aff_ds_1.dta
- prices_merged_wid.csv
- See .ado files for inputs indirectly used

OUTPUTS:
- Table 4
- Figure 7
- Figure A-13
- Figure A-14
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

global sample (abs(diff_log_medp)>.3&diff_log_medp!=.)|aff!=.
global controls i.health_plan i.ruc_yr i.mtg_num i.year i.year_med 

*** Load data ****************************************************************************
import delimited using "data/intermediate/prices_merged_wid.csv", clear
merge m:1 obs_id using data/intermediate/aff_ds_1, keep(match master) nogen
rename aff_1_1_mn aff

// Shorten price names
rename priv_p_norm_t privp
rename priv_p_norm_tm1 privp_tm1
rename med_t_use medp
rename med_tm1_use medp_tm1

// Select sample, generate variables
keep if sum_freq_use>10 & medp>0
foreach var of varlist medp medp_tm1 privp privp_tm1 {
	gen log_`var'=log(`var')
}
gen diff_log_medp = log_medp - log_medp_tm1
gen diff_log_privp = log_privp - log_privp_tm1

// Generate quantiles of aff
xtile affq = aff, nq(4)
xtile affm = aff, nq(2)

gen byte aff_pres=obs_id!=.
gen byte hi_aff=affm==2
qui foreach var of varlist affq affm ruc_yr mtg_num {
	replace `var'= 0  if `var' == .
}

*** Figure A-13 **************************************************************************
twoway (kdensity diff_log_medp if aff!=.&abs(diff_log_medp)<.5&sum_freq_use>20) ///
	(kdensity diff_log_medp if aff==.&abs(diff_log_medp)<.5&sum_freq_use>20, ///
	lpattern(dash)), legend(order(1 "RUC" 2 "No RUC")) ytitle(Density) ///
	xtitle(Change in log Medicare price) name(Figure_A13, replace)
graph export "output/Figure_A-13.eps", as(eps) replace
	
*** Table 4 ******************************************************************************
local regline1 log_medp ${controls} if aff!=.
local regline2 log_medp ${controls} if aff==.
local regline3 log_medp ${controls} if aff==.&(${sample})
local regline4 i.affm#c.log_medp hi_aff aff_pres ${controls} if ${sample}
local regline5 i.affm#c.log_medp hi_aff aff_pres ${controls} if ${sample}
estimates clear
qui foreach num of numlist 1/5 {
	if `num'==4 eststo: reg log_privp `regline`num'' [aw=sum_freq_use], `cluster'
	else eststo: areg log_privp `regline`num'' [aw=sum_freq_use], ///
		absorb(cpt_code)
	if inlist(`num',4,5) {
		test 0.affm#c.log_medp=1.affm#c.log_medp
		estadd scalar pequal01c=r(p)
		test 1.affm#c.log_medp=2.affm#c.log_medp
		estadd scalar pequal12c=r(p)
	}
	foreach var in log_privp log_medp {
		sum `var' [aw=sum_freq_use] if e(sample)
		estadd scalar `var'_mean=r(mean)
	}
	preserve
	keep if e(sample)
	keep cpt_code year_med aff diff_log_medp
	duplicates drop
	isid cpt_code year_med
	count if aff!=.
	estadd scalar N_p_RUC=r(N)
	count if aff==.
	estadd scalar N_p_nonRUC=r(N)
	restore	
}
local vars log_medp 0.affm#c.log_medp 1.affm#c.log_medp 2.affm#c.log_medp hi_aff
esttab, order(`vars') keep(`vars') cells(b(fmt(3) star) se(fmt(3) par)) varwidth(10) ///
	stats(pequal01c pequal12c N N_p_RUC N_p_nonRUC r2_a, ///
	fmt(3 3 0 0 0 3)) starlevels(* .1 ** .05 *** .01)
/*
------------------------------------------------------------------------------------------
                    (1)             (2)             (3)             (4)             (5)   
              log_privp       log_privp       log_privp       log_privp       log_privp   
                   b/se            b/se            b/se            b/se            b/se   
------------------------------------------------------------------------------------------
log_medp          0.892***        0.399***        0.300***                                
                (0.091)         (0.003)         (0.012)                                   
0.affm#c~p                                                        0.688***        0.331***
                                                                (0.016)         (0.022)   
1.affm#c~p                                                        0.838***        0.520***
                                                                (0.006)         (0.023)   
2.affm#c~p                                                        0.917***        0.642***
                                                                (0.015)         (0.041)   
hi_aff                                                           -0.420***       -0.016   
                                                                (0.040)         (0.067)   
------------------------------------------------------------------------------------------
pequal01c                                                         0.000           0.000   
pequal12c                                                         0.000           0.001   
N                  3179          184910            4003            7182            7182   
N_p_RUC            1756               0               0            1756            1756   
N_p_nonRUC            0          100342            2381            2381            2381   
r2_a              0.986           0.987           0.992           0.852           0.987   
------------------------------------------------------------------------------------------
*/

*** Figure 7 *****************************************************************************
capture program drop prep_resid
program prep_resid
syntax , [rucvars(string)]
qui {
	foreach var in yr yr0 yr1 yr2 sample {
		capture drop `var'
	}
	gen byte sample=e(sample)
	predict yr, resid
	if "`rucvars'"!="" foreach var in `rucvars' {
		if regexm("`var'","^i\.") {
			local varname `=substr("`var'",3,.)'
			levelsof `varname', local(levels)
			foreach l of local levels {
				replace yr=yr+_b[`l'.`varname'] if `varname'==`l'
			}
		}
		else replace yr=yr+_b[`var']*`var'
	}
	foreach cat of numlist 0/2 {
		gen yr`cat'=yr+_b[`cat'.affm] if affm==`cat'
		foreach var in diff_log_medp log_medp {
			capture replace yr`cat'=yr`cat'+ ///
				_b[`cat'.affm#c.`var']*`var' if affm==`cat'
		}	
	}
}
end

qui reg log_privp i.affm i.affm#c.log_medp ${controls} if ${sample} [aw=sum_freq_use]
prep_resid, rucvars(i.ruc_yr i.mtg_num)
binned_scatter if sample [aw=sum_freq_use], yvar(yr0 yr1 yr2) xvar(log_medp) ///
	ylabel(Log private price) xlabel(Log Medicare price) bins(20) ///
	overlay msymbol(Th Oh O) lpattern(dash solid solid) ///
	graphopts(legend(off) fysize(100) name(reg_l, replace) title(A: Cross Section))
	
qui areg log_privp i.affm i.affm#c.log_medp ${controls} if ${sample} ///
	[aw=sum_freq_use], absorb(cpt_code)
prep_resid, rucvars(i.ruc_yr i.mtg_num)
binned_scatter if sample [aw=sum_freq_use], yvar(yr0 yr1 yr2) xvar(log_medp) ///
	ylabel(Log private price) xlabel(Log Medicare price) bins(20) ///
	overlay msymbol(Th Oh O) lpattern(dash solid solid) ///
	graphopts(legend(label(1 "Not RUC") label(2 "Low affiliation") label(3 "High affiliation") ///
	order(1 2 3) rows(1) region(col(white))) fysize(110) name(areg_l, replace) title(B: Within Service))

graph combine reg_l areg_l, ysize(6) xsize(4) cols(1) iscale(*1.1) ///
	graphregion(color(white)) name(Figure_7, replace)
graph export "output/Figure_7.eps", as(eps) replace	

*** Figure A-14 **************************************************************************
binned_scatter if aff!=.&hi_aff==1 [aw=sum_freq_use], yvar(diff_log_privp) ///
	xvar(diff_log_medp) bins(20) addN nodemean  `color' ///
	xlabel(Log Medicare price change) ylabel(Log private price change) ///
	graphopts(legend(off) title("A: High Affiliation") name(A, replace))
binned_scatter if aff!=.&hi_aff==0 [aw=sum_freq_use], yvar(diff_log_privp) ///
	xvar(diff_log_medp) bins(20) addN nodemean `color' ///
	xlabel(Log Medicare price change) ylabel(Log private price change) ///
	graphopts(legend(off) title("B: Low Affiliation") name(B, replace))
graph combine A B, ysize(6) xsize(4) cols(1) iscale(*1.1) ycommon xcommon ///
	graphregion(color(white)) name(Figure_A14, replace)
graph export "output/Figure_A-14.eps", as(eps) replace
