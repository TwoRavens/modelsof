/*==============================================================================

* FILE: cz_other_public.do
  - Replication code for Chetty and Hendren (2017) - The Effect of 
	Neighborhoods on Intergenerational Mobility I: Childhood Exposure Effects
  - Additional replication code for this paper can be found in cz_public.do 
	and cty_public.do

* MAIN TEXT FIGURES:
  - VIII: Exposure Effects on College Attendance and Marriage
  - IX:   Exposure Effects on Teen Birth and Employment
	  
* VARIABLE DICTIONARY:
	kid_tin: child's identifier
	age_outcome: kid age at outcome measured
	cohort: child's cohort
	fam_id: child's family identifier
	kid_rank: kid family income rank at age specified by age_outcome
	par_rank_n: parent family income rank
	par_bin: parent family income decile bin
	par_cz_orig: parent origin CZ
	par_cz_dest: parent destination CZ
	coll_qual_*: College quality
	kid_dm2: An indicator for teen birth
	kid_worked_*: An indicator for teen labor force participation; =1 if positive
				  labor income earnings in a given year 
	kid_mar_age_*: Indicator for kid marital status at a given age
	distance: move distance (miles)
	pop_o: Census 2000 population in origin CZ
	pop_d: Census 2000 population in destination CZ
	
	

* NOTE: This code can't be run because the source datasets are administrative
        (restricted-access) datasets.
	
==============================================================================*/

*-------------------------------------------------------------------------------
* Setup
*-------------------------------------------------------------------------------

global filename cz_other
capture log close `filename'
log using ${filename}.log, replace name(${filename})

clear
set more off
eststo clear

*-------------------------------------------------------------------------------
* Dataset prep
*-------------------------------------------------------------------------------

use movers_v10_czotherwide.dta, clear

* Drop moves occurring in 2011/12
drop if cohort + kid_age == 2012
drop if cohort + kid_age == 2011

* Rename variables to save precious bytes
rename coll_qual_* cq*
rename coll* c*
rename kid_dm2* dm2* 
rename kid_worked_* tl*
rename kid_mar_age_* km*

* Merge on distance and extra controls
merge 1:1 kid_tin using movers_v10_czzip5_dist.dta, keep(match master) keepusing(distance) nogen
merge 1:1 kid_tin using movers_v10_czcntrl.dta, keep(match master) nogen
rename distance miles

* Merge on CZ population from 2000 Census
clonevar cz = par_cz_orig 
merge m:1 cz using ../outside_data/analysis_revision_v1, nogen assert(3)
rename pop2000 pop_o
drop cz
clonevar cz = par_cz_dest
merge m:1 cz using ../outside_data/analysis_revision_v1, nogen assert(3)
rename pop2000 pop_d
drop cz

g kid_age 	= year_move_cz - cohort
g f_d 		= 23 - kid_age
g insample 	= (pop_o>2.5e5&pop_d>2.5e5&miles>100) & !missing(miles, pop_o, pop_d)

* Make sure tl is set to missing if year before 1999
forval i = 15/18 {
	replace tl`i' 	  = . if cohort + `i' < 1999
	replace i_tl`i'_o = . if cohort + `i' < 1999
	replace s_tl`i'_o = . if cohort + `i' < 1999
	replace i_tl`i'_d = . if cohort + `i' < 1999
	replace s_tl`i'_d = . if cohort + `i' < 1999
}
	
* Save intermediate data
save ../intermediate/cz_other_intermediate_data, replace 

*-------------------------------------------------------------------------------
* Figures VIII and IX: Exposure Effects on Additional Outcomes
*-------------------------------------------------------------------------------

* Outcome start and end cohorts
local c1823_cohort_min 1981
local c1823_cohort_max 1988
local dm2_f_cohort_min 1980
local dm2_f_cohort_max 1991
local dm2_m_cohort_min 1980
local dm2_m_cohort_max 1991
local tl15_cohort_min 1984
local tl15_cohort_max 1995
local tl16_cohort_min 1983
local tl16_cohort_max 1995
local tl17_cohort_min 1982
local tl17_cohort_max 1994
local tl18_cohort_min 1981
local tl18_cohort_max 1993
local km26_cohort_min 1981
local km26_cohort_max 1985
local km24_cohort_min 1983
local km24_cohort_max 1987

foreach var in c1823 dm2_f dm2_m tl15 tl16 tl17 tl18 km26 km24 {
	
	use ../intermediate/cz_other_intermediate_data, clear
	
	*generate variables for exposure analysis
	g e_o 	= i_`var'_o + s_`var'_o * par_rank_n
	g e_d	= i_`var'_d + s_`var'_d * par_rank_n
	g d_e 	= e_d - e_o
	
	* Generate cohort controls excluding the last cohort intercept (d_e_cohort_last)
	forval c = ``var'_cohort_min'(1)``var'_cohort_max' {
		gen byte cohort_`c' = (cohort == `c')
		gen e_o_cohort_`c'  = e_o * cohort_`c'
		gen e_d_cohort_`c'  = e_d * cohort_`c'
		gen d_e_cohort_`c'  = d_e * cohort_`c'
	}
	
	* Generate exposure and diff in outcome variables
	forval i=1/32 {
		g f_d_dummy_`i'        = (kid_age == `i')
		g pe_`i'               = (kid_age == `i') * d_e
		g par_rank_n_dummy_`i' = (kid_age == `i') * par_rank_n
	}

	* Alternative Outcome Figures: Hockey stick with Cohort controls 
	_eststo hockey_`var': reg `var' pe* e_o f_d_dummy* par_rank_n_dummy_* cohort_* e_o_cohort_* d_e_cohort_* if insample == 1 
	
}

esttab using ../results/${filename}_hockeysticks.csv, se nostar nodepvar replace	

*-------------------------------------------------------------------------------
* End of file
*-------------------------------------------------------------------------------

log close ${filename}
