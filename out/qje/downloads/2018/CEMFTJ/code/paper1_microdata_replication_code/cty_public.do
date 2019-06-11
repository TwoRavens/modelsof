/*==============================================================================

* FILE: cty_public.do
  - Replication code for Chetty and Hendren (2017) - The Effect of 
	Neighborhoods on Intergenerational Mobility I: Childhood Exposure Effects
  - Additional replication code for this paper can be found in cz_public.do 
	and cz_other_public.do

* APPENDIX TABLES:
  - V:  Annual Exposure Effect Estimates at the County Level
	  
* VARIABLE DICTIONARY:
  - movers_ctywork_long.dta
	  kid_tin: child's identifier
	  age_outcome: kid age at outcome measured
	  cohort: child's cohort
	  fam_id: child's family identifier
	  kid_rank: kid family income rank at age specified by age_outcome
	  par_rank_n: parent family income rank
	  par_bin: parent family income decile bin
	  par_cz_orig: parent origin CZ
	  par_cz_dest: parent destination CZ
	  e_o: expected rank in origin
	  e_d: expected rank in destination
	  d_e: difference in expected rank (d_e=e_d-e_o)
      insample: dummy, = 1 if move distance > 100 miles and origin/destination
	            populations > 250k and = 0 otherwise
	  parrank_yrmovecz_post: parent rank in the year before move
	  parrank_yrmovecz_pre: parent rank in the year after move
	  d_par_rank: difference in parent rank across moves
	  parmar_yrmovecz_pre: parent marital status dummy in year prior to move
	  parmar_yrmovecz_post: parent marital status dummy in year after move
	  
* NOTE: This code can't be run because the source datasets are administrative
        (restricted-access) datasets.
	
==============================================================================*/

*-------------------------------------------------------------------------------
* Setup
*-------------------------------------------------------------------------------

global filename cty_public
capture log close ${filename}
log using ${filename}.log, replace name(${filename})

clear
set more off
eststo clear

*-------------------------------------------------------------------------------
* Variable Generation
*-------------------------------------------------------------------------------

* Load long county data
use movers_v10_ctywork_long.dta, clear

* Restrict to cohorts 1980-1988 who moved prior to 2011
keep if age_outcome >= 24
keep if cohort + kid_age < 2011

* Rescale exposure
replace f_d = 23 * f_d

* Old definitions. Redefined below
g f_d_d_e	  = f_d*d_e
g f_d_d_e_pos = f_d_d_e * (kid_age <= 23)
g f_d_d_e_neg = f_d_d_e * (kid_age > 23)

* This was in the old work_long file, need to create it here
egen double fam_age_fx = group(fam_id age_outcome)

* We are using a 1990 zip-cty crosswalk but 2000 Census population data. Recode a couple counties accordingly
drop pop_o pop_d
replace par_cty_orig = 12086 if par_cty_orig == 12025
replace par_cty_orig = 2232  if par_cty_orig == 2231 
replace par_cty_dest = 12086 if par_cty_dest == 12025
replace par_cty_dest = 2232  if par_cty_dest == 2231 

* Load county pops
clonevar cty = par_cty_orig
merge m:1 cty using ../outside_data/cty_pop.dta, nogen keep(3)
rename pop2000 pop_o
drop cty
clonevar cty = par_cty_dest
merge m:1 cty using ../outside_data/cty_pop.dta, nogen keep(3)
rename pop2000 pop_d
drop cty 

* Make things as small as possible
compress

* Define origin/destination CZ from counties
clonevar cty = par_cty_orig
merge m:1 cty using cty_cz_cw.dta, keep(1 3) nogen
rename cz cz_o
drop cty
clonevar cty = par_cty_dest
merge m:1 cty using cty_cz_cw.dta, keep(1 3) nogen
rename cz cz_d
drop cty 

* Generate insample restriction
g insample = (pop_o>2.5e5 & pop_d>2.5e5 & miles>100) & !missing(miles, pop_o, pop_d)

* Generate cohort controls
forval c = 1980(1)1993 {
	g cohort_`c' 	 = (cohort == `c')
	g ero_cohort_`c' = e_o * cohort_`c'
	g d_e_cohort_`c' = d_e * cohort_`c'
}

* Generate cohort controls macro
forval c = 1980(1)1993 {
	global cohort_controls "$cohort_controls cohort_`c' ero_cohort_`c' d_e_cohort_`c'"
}
order ${cohort_controls}
cap drop pe_*

* Generate exposure and dif in expected rank variables for regressions
forval i=8/32 {
	g pe_`i'				= d_e*(kid_age==`i')
	g f_d_dummy_`i' 		= (kid_age == `i')
	g ero_dummy_`i' 		= e_o * (kid_age == `i') 
	g par_rank_n_dummy_`i' 	= par_rank_n * (kid_age == `i') 
}

egen double opca = group(par_bin par_cty_orig cohort age_outcome)
g pos 				= (kid_age <= 23) 
g neg 				= (kid_age > 23)
g f_d_pos 			= f_d * pos
g f_d_neg 			= f_d * neg
g e_o_pos 			= e_o * pos 
g e_o_neg 			= e_o * neg
g d_e_pos 			= d_e * pos
g d_e_neg 			= d_e * neg 
g par_pos 			= par_rank_n * pos
g par_neg 			= par_rank_n * neg
g par_f_d 			= par_rank_n * f_d
g par_f_d_pos 		= par_rank_n * f_d * pos
g par_f_d_neg 		= par_rank_n * f_d * neg
g f_d_e_o_pos 		= f_d * e_o * pos
g f_d_e_o_neg 		= f_d * e_o * neg

replace f_d_d_e_pos = f_d_d_e * pos 
replace f_d_d_e_neg = f_d_d_e * neg

* Load mike_covariates_merge, which contains parent rank and parent marital status changes around time of move
merge m:1 kid_tin using mike_covariates_merge, nogen keepusing(dpr parmar_mm parmar_um parmar_uu parmar_mu) keep(3)

* Rename time-varying covariates to be consistent with CZ nomenclature
rename parmar_mm mar_alwaysmarried
rename parmar_uu mar_nevermarried
rename parmar_mu mar_divorced
rename dpr d_par_rank

* Generate a set of time-varying covariate interactions
foreach v in alwaysmarried nevermarried divorced {
	gen mar_`v'_f_d 	= mar_`v' * f_d
	gen mar_`v'_f_d23 	= mar_`v' * f_d * (kid_age>23)
	gen mar_`v'_23 		= mar_`v' * (kid_age>23)
}
gen f_d_d_par_rank 		= f_d * d_par_rank
gen f_d23_d_par_rank 	= f_d * (kid_age>23) * d_par_rank
gen d_par_rank23 		= (kid_age>23) * d_par_rank 

*===============================================================================
* Appendix Table V - Exposure Effect Estimates at the County Level
*===============================================================================

* Macro to store main regressors
global regressors_main 			"f_d_d_e_pos f_d_d_e_neg d_e_neg d_e_pos e_o f_d_dummy* par_rank_n_dummy_*"
global cohort_controls_age24 	"cohort_1980-cohort_1987 ero_cohort_1980-ero_cohort_1987 d_e_cohort_1980-d_e_cohort_1987"
global controls_timevarying 	"d_par_rank f_d_d_par_rank f_d23_d_par_rank d_par_rank23 mar_*"
global restrict_acrosscz 		insample == 1 & age_outcome==24 & cz_o!=cz_d & ~missing(cz_o,cz_d)
global restrict_withincz 		pop_o > 2.5e5 & pop_d > 2.5e5 & age_outcome==24 & ~missing(pop_o,pop_d) & cz_o==cz_d
global restrict_withincz_ge24 	pop_o > 2.5e5 & pop_d > 2.5e5 & age_outcome>=24 & ~missing(pop_o,pop_d) & cz_o==cz_d

* Column 1
_eststo hockey_cc_24_m: 		 reg  kid_rank ${regressors_main} ${cohort_controls_age24} 						   if ${restrict_acrosscz}
* Column 2
_eststo hockey_cc_24_fam_m: 	 reg  kid_rank ${regressors_main} ${cohort_controls_age24} 						   if ${restrict_acrosscz}, a(fam_age_fx)
* Column 3
_eststo hockey_cc_24_famp:  	 reg  kid_rank ${regressors_main} ${cohort_controls_age24} ${controls_timevarying} if ${restrict_acrosscz}, a(fam_age_fx)
* Column 4
_eststo m_250k_czr: 			 reg  kid_rank ${regressors_main} ${cohort_controls_age24} 						   if ${restrict_withincz}
* Column 5
_eststo m_250k_czr_ge24: 		 reg  kid_rank ${regressors_main} ${cohort_controls_age24} 						   if ${restrict_withincz_ge24}, cluster(kid_tin)
* Column 6
_eststo m_fam_250k_czr_ge24: 	 areg kid_rank ${regressors_main} ${cohort_controls_age24} 						   if ${restrict_withincz_ge24}, cluster(kid_tin) a(fam_age_fx)
* Column 7
_eststo m_fam_250k_czr_ge24_tvc: areg kid_rank ${regressors_main} ${cohort_controls_age24} ${controls_timevarying} if ${restrict_withincz_ge24}, cluster(kid_tin) a(fam_age_fx)

esttab using ../results/${filename}_appendix_table5.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Cleanup
*-------------------------------------------------------------------------------

log close ${filename}
