/*==============================================================================

* FILE: cz_public.do
  - Replication code for Chetty and Hendren (2017) - The Effect of 
	Neighborhoods on Intergenerational Mobility I: Childhood Exposure Effects
  - Additional replication code for this paper can be found in 
	cz_other_public.do and cty_public.do

* MAIN TEXT FIGURES:
  - III: Movers Outcomes vs Predicted Outcomes Based on Permanent Residents
  - IV:  Childhood Exposure Effects on Income Ranks in Adulthood
  - V:   Childhood Exposure Effects on Income Ranks with Additional Controls
  - VI:  Exposure Effect Estimates Using Displacement Shocks 
  - VII: Exposure Effect Estimates Based on Cross-Cohort Variation

* ONLINE APPENDIX FIGURES:
  - II:  Childhood Exposure Effects Using Variation in Origin CZs
  - III: Exposure Effects - Adjusting for Children's Rates of Moving with Parents
  - IV:  Exposure Effects - Sensitivity to Measuring Income at Older Ages
    
* MAIN TEXT TABLES:
  - II:  Exposure Effects - Robustness with Family FEs and time-varying controls
  - III: Exposure Effects - Distributional Convergence
  - IV:  Exposure Effects - Gender-Specific Convergence
  
* APPENDIX TABLES:
  - II:  Varying distance and population restrictions
  - III: Heterogeneity in exposure effects across subgroups
  - VI:  Family fixed effects: sensitivity to cohort controls and pop restrictions
	  
* VARIABLE DICTIONARY:
  - movers_czwork_long.dta
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
	
==============================================================================*/

*-------------------------------------------------------------------------------
* Setup
*-------------------------------------------------------------------------------

* Set logs
capture log close ${filename}
global filename cz_web
log using ${filename}.log, replace name(${filename})

* Clear data and set configuration
clear
eststo clear
set more off
set matsize 11000

* Define useful macros containing variables that appear in various specs
global regvars_full          "f_d_dummy* par_rank_n_dummy_* f_d_d_e_pos e_o_pos f_d_e_o_pos d_e_pos f_d_d_e_neg e_o_neg f_d_e_o_neg d_e_neg"
global regvars_full_noeo     "f_d_dummy* par_rank_n_dummy_* f_d_d_e_pos d_e_pos f_d_d_e_neg d_e_neg"
global regvars_slopes_noeo   "f_d_d_e_pos d_e_pos f_d_d_e_neg d_e_neg"
global regvars_pooled        "f_d_dummy* par_rank_n_dummy_* f_d_d_e_pos f_d_d_e_neg d_e_pos d_e_neg e_o" 
global regvars_allages_indv  "f_d_dummy* par_rank_n_dummy_* f_d_d_e_i_pos f_d_d_e_i_neg d_e_i_pos d_e_i_neg e_o_i"

* Define useful macros containing cohort controls that appear in various specs
global cohort_controls_age24 "cohort_1980-cohort_1987 e_o_cohort_1980-e_o_cohort_1987 e_d_cohort_1980-e_d_cohort_1987"
global cohort_controls_age26 "cohort_1980-cohort_1985 e_o_cohort_1980-e_o_cohort_1985 e_d_cohort_1980-e_d_cohort_1985"
global cohort_controls_age28 "cohort_1980-cohort_1983 e_o_cohort_1980-e_o_cohort_1983 e_d_cohort_1980-e_d_cohort_1983"
global cohort_controls_age30 "cohort_1980-cohort_1981 e_o_cohort_1980-e_o_cohort_1981 e_d_cohort_1980-e_d_cohort_1981"

* Define a macro with time-varying controls
global time_varying_controls "d_par_rank f_d_d_par_rank f_d23_d_par_rank d_par_rank23 mar_*"

*-------------------------------------------------------------------------------
* Dataset prep
*-------------------------------------------------------------------------------

* Load dataset of one-time movers long on kid-age_outcome
use movers_v10_czwork_long.dta, clear

* Keep only outcomes at ages we're interested in
keep if age_outcome == 24 | age_outcome == 26 | age_outcome == 28 | age_outcome == 30

* Sampling restriction: destination for at least 2 years (one-time movers, so <=2010)
drop if (cohort + kid_age == 2012) | (cohort + kid_age == 2011)

* Merge on kid cz, move distance, par_zip5 origin and destination
merge m:1 kid_tin using movers_v10_cz_otherwidevars.dta , keepusing(kid_cz_2011 kid_cz_2012) keep(3) assert(2 3) nogen
merge m:1 kid_tin using movers_v10_czzip5_dist.dta , keepusing(distance par_zip5_orig par_zip5_dest) keep(3) assert(2 3) nogen

* Define standard errors
global se = ""

* Generate kid_cohort controls
forval c = 1980(1)1993 {
	gen byte cohort_`c' = (cohort == `c')
	gen e_o_cohort_`c'  = e_o * cohort_`c'
	gen e_d_cohort_`c'  = e_d * cohort_`c'
	gen d_e_cohort_`c'  = d_e * (cohort == `c')
	global cohort_controls "$cohort_controls cohort_`c' e_o_cohort_`c' e_d_cohort_`c'  d_e_cohort_`c'"
}
order ${cohort_controls}

* Generate fixed effects
egen fam_age_fx   = group(fam_id age_outcome)
egen double opca  = group(par_bin par_cz_orig cohort age_outcome)
egen double dpca  = group(par_bin par_cz_dest cohort age_outcome)
egen double opcma = group(par_bin par_cz_orig cohort age_outcome kid_age)
egen double dpcma = group(par_bin par_cz_dest cohort age_outcome kid_age)

* Generate kid age indicators and interactions with d_e, e_o, par_rank_n
forval i=8/32 {
	gen byte f_d_dummy_`i'   = (kid_age == `i')
	gen pe_`i'			   	 = (kid_age == `i') * d_e
	gen e_o_dummy_`i' 	   	 = (kid_age == `i') * e_o
	gen par_rank_n_dummy_`i' = (kid_age == `i') * par_rank_n
}

* Create indicators and interactions
gen pos 		= (kid_age <= 23) 
g neg 			= (kid_age > 23)
g f_d_pos 		= f_d * pos
g f_d_neg 		= f_d * neg
g e_o_pos 		= e_o * pos 
g e_o_neg 		= e_o * neg
g e_d_pos 		= e_d * pos
g e_d_neg 		= e_d * neg 
g f_d_e_d		= f_d * e_d 
g par_pos 		= par_rank_n * pos
g par_neg 		= par_rank_n * neg
g par_f_d 		= par_rank_n * f_d
g par_f_d_pos 	= par_rank_n * f_d * pos
g par_f_d_neg 	= par_rank_n * f_d * neg
g f_d_e_o_pos 	= f_d * e_o * pos
g f_d_e_o_neg 	= f_d * e_o * neg
g f_d_e_d_pos 	= f_d_e_d * pos 
g f_d_e_d_neg 	= f_d_e_d * neg

cap drop d_e
g d_e			= e_d - e_o		
g f_d_d_e 		= f_d*d_e
g f_d_d_e_pos 	= f_d * d_e * pos 
g f_d_d_e_neg 	= f_d * d_e * neg 
g d_e_pos 		= d_e * pos 
g d_e_neg 		= d_e * neg 

merge m:1 kid_tin using movers_v10_czcntrl.dta, keep(match master) nogen
g d_par_rank 				= parrank_yrmovecz_post - parrank_yrmovecz_pre
g f_d_d_par_rank 			= f_d * d_par_rank
g f_d23_d_par_rank 			= f_d*(kid_age > 23) * d_par_rank
g d_par_rank23 				= (kid_age > 23) * d_par_rank
g mar_alwaysmarried		 	= (parmar_yrmovecz_pre == 1 & parmar_yrmovecz_post == 1)
g mar_nevermarried 			= (parmar_yrmovecz_pre == 0 & parmar_yrmovecz_post == 0)
g mar_divorced 				= (parmar_yrmovecz_pre == 1 & parmar_yrmovecz_post == 0)
g mar_alwaysmarried_f_d 	= (parmar_yrmovecz_pre == 1 & parmar_yrmovecz_post == 1)*f_d
g mar_nevermarried_f_d 		= (parmar_yrmovecz_pre == 0 & parmar_yrmovecz_post == 0)*f_d
g mar_divorced_f_d 			= (parmar_yrmovecz_pre == 1 & parmar_yrmovecz_post == 0)*f_d
g mar_alwaysmarried_f_d23 	= (parmar_yrmovecz_pre == 1 & parmar_yrmovecz_post == 1)*f_d*(kid_age > 23)
g mar_nevermarried_f_d23 	= (parmar_yrmovecz_pre == 0 & parmar_yrmovecz_post == 0)*f_d*(kid_age > 23)
g mar_divorced_f_d23 		= (parmar_yrmovecz_pre == 1 & parmar_yrmovecz_post == 0)*f_d*(kid_age > 23)
g mar_alwaysmarried_23 		= (parmar_yrmovecz_pre == 1 & parmar_yrmovecz_post == 1)*(kid_age > 23)
g mar_nevermarried_23 		= (parmar_yrmovecz_pre == 0 & parmar_yrmovecz_post == 0)*(kid_age > 23)
g mar_divorced_23 			= (parmar_yrmovecz_pre == 1 & parmar_yrmovecz_post == 0)*(kid_age > 23)

save ../intermediate/cz_intermediate_data, replace

*-------------------------------------------------------------------------------
* Figure III - Movers Outcomes vs Predicted Outcomes
*-------------------------------------------------------------------------------

use ../intermediate/cz_intermediate_data.dta, clear

binscatter kid_rank d_e if insample==1 & kid_age==13 & age_outcome==24, absorb(opca) savegraph(../results/${filename}_figure3.gph) savedata(../results/${filename}_figure3) replace

*-------------------------------------------------------------------------------
* Figure IV - Childhood Exposure Effects on Income Ranks in Adulthood
*-------------------------------------------------------------------------------

* Fig IVa
_eststo hockey_opcma_24: 	areg kid_rank pe*  						d_e_cohort_1980 d_e_cohort_1981 d_e_cohort_1982 d_e_cohort_1983 d_e_cohort_1984 d_e_cohort_1985 d_e_cohort_1986 d_e_cohort_1987 if insample == 1 & age_outcome == 24 , a(opcma)
_eststo hockey_opcma_24_m: 	areg kid_rank ${regvars_slopes_noeo} 	d_e_cohort_1980 d_e_cohort_1981 d_e_cohort_1982 d_e_cohort_1983 d_e_cohort_1984 d_e_cohort_1985 d_e_cohort_1986 d_e_cohort_1987 if insample == 1 & age_outcome == 24 , a(opcma)

* Fig IVb
_eststo hockey_24_cc_pool: 	  	reg kid_rank pe* 					f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age24} if insample == 1 & age_outcome == 24 
_eststo hockey_24_cc_pool_m: 	reg kid_rank ${regvars_pooled} 		f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age24} if insample == 1 & age_outcome == 24

esttab using ../results/${filename}_figure4.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Figure V - Childhood Exposure Effects on Income Ranks with Additional Controls
*-------------------------------------------------------------------------------

* Figure Va
_eststo hockey_24_cc_poolfam: 	areg kid_rank pe* 				f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age24} if insample == 1 & age_outcome == 24, a(fam_age_fx) $se 
_eststo hockey_24_cc_poolfam_m: reg kid_rank ${regvars_pooled}  f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age24} if insample == 1 & age_outcome == 24, a(fam_age_fx) $se 

* Figure Vb
_eststo hockey_cc_fam_inc_mar: 	 areg kid_rank pe* 						f_d_dummy* e_o par_rank_n_dummy_* ${time_varying_controls} ${cohort_controls_age24} if insample == 1 & age_outcome==24 , a(fam_age_fx)  $se 
_eststo hockey_cc_fam_inc_mar_m: areg kid_rank ${regvars_slopes_noeo} 	f_d_dummy* e_o par_rank_n_dummy_* ${time_varying_controls} ${cohort_controls_age24} if insample == 1 & age_outcome==24 , a(fam_age_fx)  $se 

esttab using ../results/${filename}_figure5.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Figure VI - Exposure Effect Estimates Using Displacement Shocks
*-------------------------------------------------------------------------------

use ../intermediate/cz_intermediate_data.dta, clear

keep if age_outcome==24

rename par_zip5_orig par_zip5
g tax_yr = year_move_last_cz

* Merge on zip outflow information
merge m:1 tax_yr par_zip5 using zip_outflow, keep(match master) nogen
ren par_zip5 par_zip5_orig

* Identify shocks to county outflows
local shockmax = 50
capture drop shock_within
capture drop shock_q
g shock_within = d_zip5
xtile shock_q = shock_within if insample==1 & age_outcome == 24 & shock_within < . & left_zip5>10 , nq(`shockmax')
levelsof shock_q, local(shock_q)

egen medshock = median(shock_within) if insample==1 & age_outcome == 24 & shock_within < .  & left_zip5>10

* County-par bin-year fx for clustering
egen long zpy = group(par_zip5_orig par_bin year_move_last)

* Define mean_d_e_rank based on shock year 
bys par_zip5_orig age_outcome par_bin: egen mean_d_e = mean(d_e) if insample == 1 
bys par_zip5_orig age_outcome par_bin: egen mean_e_o = mean(e_o) if insample == 1 
bys par_zip5_orig age_outcome par_bin: egen N_zip5o = count(e_d) if insample == 1

su N_zip5o, d
mat  nzip5o = (r(N) \ r(mean) \ r(sd) \ r(p5) \ r(p10) \ r(p25) \ r(p50) \ r(p75) \ r(p90) \ r(p95)) 
mat rownames nzip5o = N Mean SD p5 p10 p25 p50 p75 p90 p95
esttab matrix(nzip5o) using ../draft/nzip5o.csv , replace substitute(`"""' `""' "=" "")

g f_d_mean_d_e_pos 	= f_d*mean_d_e*(kid_age <= 23)
g f_d_mean_d_e_neg 	= f_d*mean_d_e*(kid_age > 23)
g f_d_mean_d_e 		= f_d*mean_d_e
g mean_d_e_pos 		= mean_d_e * (kid_age <= 23) 
g mean_d_e_neg 		= mean_d_e * (kid_age > 23) 
g mean_e_o_f_d 		= mean_e_o*f_d
g mean_e_o_f_d_pos 	= mean_e_o*f_d*(kid_age <= 23)
g mean_e_o_f_d_neg 	= mean_e_o*f_d*(kid_age > 23)
g mean_e_o_pos 		= mean_e_o * (kid_age <= 23)
g mean_e_o_neg 		= mean_e_o * (kid_age > 23)

forval c = 1980(1)1987 {
	g mean_e_o_cohort_`c' = mean_e_o * cohort_`c'
	g mean_d_e_cohort_`c' = mean_d_e * cohort_`c'
}

compress

global regvars_allages 		"f_d_dummy_* par_rank_n_dummy_* f_d_d_e_pos f_d_d_e_neg d_e_pos d_e_neg e_o"
global regvars_allages_mean	"f_d_dummy_* par_rank_n_dummy_* f_d_mean_d_e_pos f_d_mean_d_e_neg mean_d_e_pos mean_d_e_neg mean_e_o"
global cohort_controls_mean "mean_e_o_cohort_* mean_d_e_cohort_* cohort_*"
global cohort_controls 		"e_o_cohort_* e_d_cohort_*"
	
matrix d = .
matrix a = .
matrix m = .
eststo clear

forval q=1/`shockmax'  {
	noi di "`q' of `shockmax'"
	_eststo katrina24_cc_ind0`q' : 			qui reg   kid_rank $regvars_allages 	   ${cohort_controls_age24}	if insample == 1 & age_outcome == 24 & shock_q>=`q' & shock_q<., cluster(zpy)
	_eststo katrina24_cc_mean0`q' : 		qui reg   kid_rank ${regvars_allages_mean} cohort_* mean_e_o_cohort_* mean_d_e_cohort_* if insample == 1 & age_outcome == 24 & shock_q>=`q' & shock_q<., cluster(zpy)
	_eststo katrina24_cc_meaniv0`q' : 		qui ivreg kid_rank (f_d_d_e_pos f_d_d_e_neg d_e_pos d_e_neg e_o ${cohort_controls} = $regvars_allages_mean ${cohort_controls_mean} ) if insample == 1 & age_outcome == 24 & shock_q>=`q' & shock_q<., cluster(zpy)
	_eststo katrina24_cc_meaniv0_n25`q' : 	qui ivreg kid_rank (f_d_d_e_pos f_d_d_e_neg d_e_pos d_e_neg e_o ${cohort_controls} = $regvars_allages_mean ${cohort_controls_mean} ) if insample == 1 & age_outcome == 24 & shock_q>=`q' & shock_q<. & N_zip5 > 25, cluster(zpy)
	_eststo katrina24_cc_meaniv0_n50`q' : 	qui ivreg kid_rank (f_d_d_e_pos f_d_d_e_neg d_e_pos d_e_neg e_o ${cohort_controls} = $regvars_allages_mean ${cohort_controls_mean} ) if insample == 1 & age_outcome == 24 & shock_q>=`q' & shock_q<. & N_zip5 > 50, cluster(zpy)
	_eststo katrina24_cc_meaniv0_n100`q' : 	qui ivreg kid_rank (f_d_d_e_pos f_d_d_e_neg d_e_pos d_e_neg e_o ${cohort_controls} = $regvars_allages_mean ${cohort_controls_mean} ) if insample == 1 & age_outcome == 24 & shock_q>=`q' & shock_q<. & N_zip5 > 100, cluster(zpy)
	
	tabstat shock_within if insample == 1 & age_outcome == 24 &shock_q>=`q' & shock_q<. , stats(min) save
	matrix d = d \ r(StatTotal)
	tabstat shock_within if insample == 1 & age_outcome == 24 &shock_q>=`q' & shock_q<., stats(mean) save
	matrix a = a \ r(StatTotal)
	tabstat shock_within if insample == 1 & age_outcome == 24 &shock_q>=`q' & shock_q<., stats(max) save
	matrix m = m \ r(StatTotal)
}

esttab katrina24_cc_ind* katrina24_cc_mean* using ../results/${filename}_figure6_zip5.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
esttab matrix(d) using ../results/${filename}_figure6_min_zip5.csv, replace substitute(`"""' `""' "=" "")
esttab matrix(a) using ../results/${filename}_figure6_avg_zip5.csv, replace substitute(`"""' `""' "=" "")
esttab matrix(m) using ../results/${filename}_figure6_max_zip5.csv, replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Figure VII - Exposure Effect Estimates Based on Cross-Cohort Variation
*-------------------------------------------------------------------------------

use ../intermediate/cz_intermediate_data, clear
keep if age_outcome == 24 

* Define neighboring kid_cohort place effects
rename cohort real_cohort
gen cohort= .
forval c = -4(1)4 {

	local cname = `c' + 100
	replace cohort= real_cohort + `c'
	rename par_cz_orig cz

	merge m:1 cz cohort age_outcome using movers_v10s_peczcohort.dta, nogen keepusing(i_kr s_kr) 

	gen e_o`cname' 	= i_kr + s_kr * par_rank_n 
	gen f_d_e_o`cname' = f_d * e_o`cname'

	rename cz par_cz_orig
	rename par_cz_dest cz
	drop i_kr s_kr

	merge m:1 cz cohort age_outcome using movers_v10s_peczcohort.dta, nogen keepusing(i_kr s_kr) 

	gen e_d`cname'	 = i_kr + s_kr * par_rank_n 
	gen f_d_e_d`cname' = f_d * e_d`cname'

	rename cz par_cz_dest
	drop i_kr s_kr

	gen d_e`cname'         = e_d`cname' - e_o`cname' 
	gen f_d_d_e`cname'     = f_d * d_e`cname'
	gen f_d_d_e_pos`cname' = f_d_d_e`cname' * (kid_age <= 23)
	gen f_d_d_e_neg`cname' = f_d_d_e`cname' * (kid_age >  23)
	gen f_d_e_o_pos`cname' = f_d_e_o`cname' * (kid_age <= 23)
	gen f_d_e_o_neg`cname' = f_d_e_o`cname' * (kid_age >  23)
	gen d_e_pos`cname' 	   = d_e`cname' 	* (kid_age <= 23) 
	gen d_e_neg`cname' 	   = d_e`cname'     * (kid_age >  23) 
}

* Replace missings with zero so that we can run unbalanced regressions; define "outrangej" to indicate observation is missing in window j
forval c = -4(1)4 {
	local cname = `c' + 100 
	gen outrange`cname' 	   = (e_o`cname' == .) 
	replace e_o`cname' 		   = 0 if outrange`cname' == 1 
	replace f_d_e_o`cname' 	   = 0 if outrange`cname' == 1 
	replace d_e`cname' 		   = 0 if outrange`cname' == 1 
	replace f_d_d_e`cname' 	   = 0 if outrange`cname' == 1 
	replace d_e_pos`cname' 	   = 0 if outrange`cname' == 1 
	replace d_e_neg`cname' 	   = 0 if outrange`cname' == 1 
	replace f_d_d_e_pos`cname' = 0 if outrange`cname' == 1 
	replace f_d_d_e_neg`cname' = 0 if outrange`cname' == 1 
}

forval j = 96(1)104 {
	global c`j' 	= "f_d_d_e_pos`j' f_d_d_e_neg`j' d_e_pos`j' d_e_neg`j' e_o`j' outrange`j'"
}

global controls 	= "f_d_dummy_* par_rank_n_dummy_*"

eststo clear

* Regressions whose coefficients produce Figure VII
_eststo cohort_cc: 		  reg kid_rank $c100 $c96 $c97 $c98 $c99 $c101 $c102 $c103 $c104  ${controls} 	${cohort_controls} if insample ==1 & age_outcome == 24 ,  $se 

* Hypothesis tests for leading and lagging coeffs
test f_d_d_e_pos96 == f_d_d_e_pos97 == f_d_d_e_pos98 == f_d_d_e_pos99 == f_d_d_e_pos101 == f_d_d_e_pos102 == f_d_d_e_pos103 == f_d_d_e_pos104
test f_d_d_e_pos100 == 0
test f_d_d_e_pos96 == f_d_d_e_pos97 == f_d_d_e_pos98 == f_d_d_e_pos99 == f_d_d_e_pos100 == f_d_d_e_pos101 == f_d_d_e_pos102 == f_d_d_e_pos103 == f_d_d_e_pos104
test f_d_d_e_pos100 == (1/8)*f_d_d_e_pos96 + (1/8)*f_d_d_e_pos97 + (1/8)*f_d_d_e_pos98 + (1/8)*f_d_d_e_pos99 +  (1/8)*f_d_d_e_pos101 + (1/8)*f_d_d_e_pos102 + (1/8)*f_d_d_e_pos103 + (1/8)*f_d_d_e_pos104
test f_d_d_e_pos100 == (1/2)*f_d_d_e_pos99 + (1/2)*f_d_d_e_pos101 
test f_d_d_e_pos100 == (1/4)*f_d_d_e_pos98 + (1/4)*f_d_d_e_pos99 +  (1/4)*f_d_d_e_pos101 + (1/4)*f_d_d_e_pos102
test f_d_d_e_pos100 == (1/6)*f_d_d_e_pos97 + (1/6)*f_d_d_e_pos98 + (1/6)*f_d_d_e_pos99 +  (1/6)*f_d_d_e_pos101 + (1/6)*f_d_d_e_pos102 + (1/6)*f_d_d_e_pos103

* Separate Series
forval j = 96(1)104 {
	_eststo cohort_cc`j': reg kid_rank f_d_d_e_pos`j' f_d_d_e_neg`j' d_e_pos`j' d_e_neg`j' e_o`j' ${controls} 	${cohort_controls} if insample ==1 & age_outcome == 24 ,  $se 
}

esttab using ../results/${filename}_figure7.csv,  se nostar nodepvar replace
eststo clear

*-------------------------------------------------------------------------------
* Online Appendix Figure II - Exposure Effect Estimates Using Origin Variation
*-------------------------------------------------------------------------------

global d_e_cohort_controls "d_e_cohort_1980 d_e_cohort_1981 d_e_cohort_1982 d_e_cohort_1983 d_e_cohort_1984 d_e_cohort_1985 d_e_cohort_1986 d_e_cohort_1987"

_eststo hockey_dpcma_24: 	areg kid_rank pe*  					 ${d_e_cohort_controls} if insample == 1 & age_outcome == 24 , a(dpcma)
_eststo hockey_dpcma_24_m: 	areg kid_rank ${regvars_slopes_noeo} ${d_e_cohort_controls} if insample == 1 & age_outcome == 24 , a(dpcma)

esttab matrix(mu) using ../results/${filename}_appendix_figure2.csv , replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Online Appendix Figure III - Exposure Effects Adjusting for Children's Rates of Moving
*-------------------------------------------------------------------------------

merge m:1 kid_tin using movers_v10_cz_otherwidevars.dta , keepusing(par_rank*) keep(3) assert(2 3) nogen
merge m:1 kid_tin using movers_indest_1098t_cz.dta, keep(match master) keepusing(indest_kid indest_1098t) nogen

* Add vars for claiming kids in destinations
ren claimedafter_dest kid_claimed
gen indest = 0
replace indest = 1 if kid_claimed == 1 & kid_age<=18
replace indest = 1 if indest_kid == 1 
replace indest = 1 if indest_1098t == 1 
	
* Now start w/ actual IV analysis
g f_d_iv = . 
matrix mu = [.,.]
forval age = 9(1)32 {
        su indest if kid_age == `age' & insample == 1 & age_outcome == 24
		gen mu_`age' = r(mean)
		matrix mu    = (mu \ (r(mean),`age'))
        if `age'<=23 {
			replace f_d_iv = (23 - kid_age)/mu_`age' if kid_age==`age'
		}
}

gen f_d_d_e_pos_iv  = f_d_iv * d_e * pos
gen f_d_pos_iv 		= f_d_iv * pos
gen f_d_e_o_pos_iv  = f_d_iv * e_o * pos

global regvars_iv = " f_d_dummy* par_rank_n_dummy_* f_d_d_e_pos_iv e_o_pos f_d_e_o_pos_iv d_e_pos f_d_d_e_neg e_o_neg f_d_e_o_neg d_e_neg "

_eststo robust_cc_iv:		reg  kid_rank ${regvars_iv} 	${cohort_controls_age24}	if insample == 1 & age_outcome == 24, $se 
_eststo robust_cc_l18: 		reg  kid_rank ${regvars_iv}  	${cohort_controls_age24} 	if insample == 1 & age_outcome == 24 & kid_age <= 18, $se 
_eststo robust_opca_iv:		areg kid_rank ${regvars_iv} 								if insample == 1 & age_outcome == 24, absorb(opca) $se 

_eststo robust_pool_cc_famclust: reg kid_rank ${regvars_pooled} ${cohort_controls_age24} if insample == 1 & age_outcome == 24, vce(cluster fam_id)
_eststo robust_pool_cc_kaclust:  reg kid_rank ${regvars_pooled} ${cohort_controls_age24} if insample == 1 & age_outcome == 24, vce(cluster kid_age)
_eststo robust_pool_cc_cclust:   reg kid_rank ${regvars_pooled} ${cohort_controls_age24} if insample == 1 & age_outcome == 24, vce(cluster cohort)

esttab matrix(mu) using ../results/${filename}_appendix_figure3.csv , replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Online Appendix Figure IV - Sensitivity to Measuring Income at Older Ages
*-------------------------------------------------------------------------------

_eststo hockey_26_cc_pool: 	  	reg kid_rank pe* 					f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age26} if insample == 1 & age_outcome == 26
_eststo hockey_28_cc_pool: 	  	reg kid_rank pe* 					f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age28} if insample == 1 & age_outcome == 28
_eststo hockey_30_cc_pool: 	  	reg kid_rank pe* 					f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age30} if insample == 1 & age_outcome == 30 

_eststo hockey_26_cc_pool_m: 	reg kid_rank ${regvars_pooled} 		f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age26} if insample == 1 & age_outcome == 26
_eststo hockey_28_cc_pool_m: 	reg kid_rank ${regvars_pooled} 		f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age28} if insample == 1 & age_outcome == 28
_eststo hockey_30_cc_pool_m: 	reg kid_rank ${regvars_pooled} 		f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age30} if insample == 1 & age_outcome == 30

* These specs explained and grouped by figure later in file, but need to include them in geo_hockey.csv
_eststo hockey_24_cc_pool_m: 	reg kid_rank ${regvars_pooled} f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age24} if insample == 1 & age_outcome == 24
_eststo hockey_24_cc_poolfam: 	areg kid_rank pe* f_d_dummy* e_o par_rank_n_dummy_* ${cohort_controls_age24} if insample == 1 & age_outcome==24, a(fam_age_fx)
_eststo hockey_cc_fam_pool_mar: areg kid_rank pe* f_d_dummy* e_o par_rank_n_dummy_* d_par_rank f_d_d_par_rank f_d23_d_par_rank d_par_rank23 mar_* ${cohort_controls_age24} if insample == 1 &age_outcome==24, a(fam_age_fx)

esttab using ../results/${filename}_appendix_figure4.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Table II - Childhood Exposure Effect Estimates
*-------------------------------------------------------------------------------

use ../intermediate/cz_intermediate_data.dta, clear

* Variable Prep
merge m:1 kid_tin using movers_v10_cz_otherwidevars.dta , keepusing(par_rank*) keep(3) assert(2 3) nogen
merge m:1 kid_tin using movers_indest_1098t_cz.dta, keep(match master) keepusing(indest_kid indest_1098t) nogen

* Add vars for claiming kids in destinations
ren claimedafter_dest kid_claimed

* Add variables for individual income specification
g d_e_i 		= e_d_i - e_o_i
g e_o_i_pos 	= e_o_i * pos 
g e_o_i_neg 	= e_o_i * neg
g e_d_i_pos 	= e_d_i * pos
g e_d_i_neg 	= e_d_i * neg 
g d_e_i_pos 	= e_d_i_pos - e_o_i_pos
g d_e_i_neg 	= e_d_i_neg - e_o_i_neg
g f_d_e_d_i_pos = f_d * e_d_i_pos 
g f_d_e_d_i_neg = f_d * e_d_i_neg
g f_d_e_o_i_pos = f_d * e_o_i_pos 
g f_d_e_o_i_neg = f_d * e_o_i_neg
g f_d_d_e_i_pos = f_d_e_d_i_pos - f_d_e_o_i_pos
g f_d_d_e_i_neg = f_d_e_d_i_neg - f_d_e_o_i_neg

capture drop d_e_pos d_e_neg
g d_e_pos = d_e * (kid_age <= 23)
g d_e_neg = d_e * (kid_age > 23)

forval c = 1980(1)1993 {
	g e_o_i_cohort_`c' = e_o_i * cohort_`c'
	g e_d_i_cohort_`c' = e_d_i * cohort_`c'
}

* Gen vars controlling for kid_CZ in 2012 to use as a FE
gen kid_cz_2011_2012 = kid_cz_2012
replace kid_cz_2011_2012 = kid_cz_2011 if missing(kid_cz_2012)
egen kid_cz_c = group(kid_cz_2011_2012 cohort)

* Column 1
_eststo robust_cc: 		 	reg kid_rank 	 ${regvars_pooled} ${cohort_controls_age24} 						  if insample == 1 & age_outcome == 24
* Column 2
_eststo robust_cc_l23: 	 	reg kid_rank 	  ${regvars_pooled} ${cohort_controls_age24} 						  if insample == 1 & age_outcome == 24 & kid_age <= 23
* Column 3 
_eststo robust_cc_b18: 	 	reg kid_rank 	  ${regvars_pooled} ${cohort_controls_age24} 						  if insample == 1 & age_outcome == 24 & kid_age < 18
* Column 4
_eststo robust_pool: 	 	reg kid_rank 	  ${regvars_pooled} 												  if insample == 1 & age_outcome == 24
* Column 5
_eststo robust_indv_cc: 	reg kid_indv_rank ${regvars_allages_indv} ${cohort_controls_age24}  				  if insample == 1 & age_outcome == 24
* Column 6
_eststo robust_kidcz_fe: 	areg kid_rank 	  ${regvars_pooled} ${cohort_controls_age24} 						  if insample == 1 & age_outcome == 24, absorb(kid_cz_c)
* Column 7
_eststo robust_pfam_cc:  	reg kid_rank 	  ${regvars_pooled} ${cohort_controls_age24} 	    				  if insample == 1 & age_outcome == 24, absorb(fam_age_fx)
* Column 8
_eststo robust_pfam: 	  	reg kid_rank 	  ${regvars_pooled}  												  if insample == 1 & age_outcome == 24, absorb(fam_age_fx)
* Column 9
_eststo robust_cc_famp_m: 	areg kid_rank 	  ${regvars_pooled} ${cohort_controls_age24} ${time_varying_controls} if insample == 1 & age_outcome == 24, absorb(fam_age_fx)

esttab using ../results/${filename}_table2.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Table III - Childhood Exposure Effect Estimates: Distributional Convergence
*-------------------------------------------------------------------------------

use ../intermediate/cz_intermediate_data, clear

keep if age_outcome == 24
clonevar age = age_outcome
merge 1:1 kid_tin age using movers_v10_czstackages.dta, keep(match master) nogen keepusing(kid_worked)
gen kid_p90 = (kid_rank > 0.9) 
gen kid_p75 = (kid_rank > .75) 

* Merge on quadratic employment place effects for origin and destination
rename par_cz_orig cz
merge m:1 cohort cz age using pe_kw24_quadratic.dta, keepusing(i_emp s_emp s_sq_emp) keep(master match) nogen
gen e_o_emp = i_emp + par_rank_n*s_emp + s_sq_emp*par_rank_n^2
drop i_emp s_emp s_sq_emp
rename cz par_cz_orig
rename par_cz_dest cz
merge m:1 cohort cz age using pe_kw24_quadratic.dta, keepusing(i_emp s_emp s_sq_emp) keep(master match) nogen
gen e_d_emp = i_emp + par_rank_n*s_emp + s_sq_emp*par_rank_n^2
drop i_emp s_emp s_sq_emp
rename cz par_cz_dest

* Define some regressors based on employment place effects
gen d_e_emp 			= e_d_emp - e_o_emp
gen d_e_emp_pos 		= d_e_emp * (kid_age<=23)
gen d_e_emp_neg 		= d_e_emp * (kid_age>23)
gen f_d_d_e_emp_pos 	= f_d * d_e_emp * (kid_age <= 23)
gen f_d_d_e_emp_neg 	= f_d * d_e_emp * (kid_age > 23)

* Merge on p90 place effects for origin and destination
rename par_cz_orig cz
merge m:1 cohort cz age using movers_v10_czotherpelong.dta , keepusing(s_p90 s_sq_p90 i_p90) keep(master match) nogen
gen e_90_o 	= i_p90 + s_p90 * par_rank_n + s_sq_p90 * par_rank_n ^ 2 
drop s_p90 s_sq_p90 i_p90
rename cz par_cz_orig 
rename par_cz_dest cz
merge m:1 cohort cz age using movers_v10_czotherpelong.dta , keepusing(s_p90 s_sq_p90 i_p90) keep(master match) nogen
gen e_90_d 	= i_p90 + s_p90 * par_rank_n + s_sq_p90 * par_rank_n ^ 2 
drop s_p90 s_sq_p90 i_p90
rename cz par_cz_dest

* Define some regressors based on p90 place effects
gen d_e_90 		   = e_90_d - e_90_o
gen f_d_d_e_90_pos = f_d * d_e_90 * (kid_age <= 23) 
gen f_d_d_e_90_neg = f_d * d_e_90 * (kid_age > 23) 
gen d_e_90_pos 	   = d_e_90 * (kid_age <= 23) 
gen d_e_90_neg 	   = d_e_90 * (kid_age > 23) 

global p90_vars  = " f_d_d_e_90_pos f_d_d_e_90_neg d_e_90_pos d_e_90_neg e_90_o " 
global mean_vars = " f_d_d_e_pos f_d_d_e_neg d_e_pos d_e_neg  e_o "
global inc_con   = " f_d_dummy_* par_rank_n_dummy_* " 
global u_vars    = " f_d_d_e_u_pos f_d_d_e_u_neg d_e_u_pos d_e_u_neg e_u_o " 
global emp_vars  = " f_d_d_e_emp_pos f_d_d_e_emp_neg d_e_emp_pos d_e_emp_neg e_o_emp"

* Want last kid_cohort to be omitted category
forval c = 1980(1)1988 {
	gen e_o_p90_cohort_`c' = e_90_o * cohort_`c'
	gen e_d_p90_cohort_`c' = e_90_d * cohort_`c'
	gen e_o_emp_cohort_`c' = e_o_emp * cohort_`c'
	gen e_d_emp_cohort_`c' = e_d_emp * cohort_`c'
}

* Define some macros with cohort controls
global cohort_controls_p90 	cohort_* e_o_p90_cohort_* e_d_p90_cohort_* 
global cohort_controls_emp 	cohort_* e_o_emp_cohort_* e_d_emp_cohort_* 

* Column 1
_eststo dist_90_cc: 	 reg kid_p90 ${p90_vars}		  	  ${inc_con} ${cohort_controls_p90} if insample == 1 & age_outcome==24, $se 
* Column 2
_eststo dist_90_mean_cc: reg kid_p90 ${mean_vars}  		  	  ${inc_con} ${cohort_controls_p90} if insample == 1 & age_outcome==24, $se 
* Column 3
_eststo dist_90_both_cc: reg kid_p90 ${p90_vars} ${mean_vars} ${inc_con} ${cohort_controls_p90} if insample == 1 & age_outcome==24, $se 

esttab using ../results/${filename}_table3_p90.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

* Column 4
_eststo dist_emp_cc: 	  reg kid_worked ${emp_vars} 			  ${inc_con} ${cohort_controls_emp} if insample == 1 & age_outcome==24, $se 
* Column 5
_eststo dist_emp_mean_cc: reg kid_worked ${mean_vars} 		 	  ${inc_con} ${cohort_controls_emp} if insample == 1 & age_outcome==24, $se 
* Column 6 
_eststo dist_emp_both_cc: reg kid_worked ${emp_vars} ${mean_vars} ${inc_con} ${cohort_controls_emp} if insample == 1 & age_outcome==24, $se 

esttab using ../results/${filename}_table3_emp.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Table IV - Childhood Exposure Estimates: Gender-Specific Convergence
*-------------------------------------------------------------------------------

* Load data
use ../intermediate/cz_intermediate_data, clear

* Generate own/other-gender family income place effects in origin CZ
rename par_cz_orig cz
merge m:1 cz cohort male age_outcome using movers_v10s_peczcohortgnd.dta, nogen keepusing(i_kr_own i_kr_other s_kr_own s_kr_other) 
gen e_o_own 		= i_kr_own + s_kr_own * par_rank_n 
gen e_o_other 	    = i_kr_other + s_kr_other * par_rank_n 
gen f_d_e_o_own 	= f_d * e_o_own
rename cz par_cz_orig
drop i_kr_own i_kr_other s_kr_own s_kr_other 

* Generate own/other-gender family income place effects in destination CZ
rename par_cz_dest cz
merge m:1 cz cohort male age_outcome using movers_v10s_peczcohortgnd.dta, nogen keepusing(i_kr_own i_kr_other s_kr_own s_kr_other) 
gen e_d_own 		= i_kr_own + s_kr_own * par_rank_n 
gen e_d_other		= i_kr_other + s_kr_other * par_rank_n 
gen f_d_e_d_own 	= f_d * e_d_own
rename cz par_cz_dest
drop i_kr_own i_kr_other s_kr_own s_kr_other 

* Variable prep part 1
gen f_d_e_o_other 	    = f_d * e_o_other
gen d_e_own 			= e_d_own - e_o_own 
gen d_e_other 		    = e_d_other - e_o_other
gen f_d_d_e_other 	    = f_d * d_e_other 
gen f_d_d_e_own 		= f_d * d_e_own 
gen f_d_d_e_own_pos 	= f_d_d_e_own * ( kid_age <= 23 )
gen f_d_d_e_own_neg 	= f_d_d_e_own * ( kid_age > 23 )
gen f_d_d_e_other_pos   = f_d_d_e_other * ( kid_age <= 23 )
gen f_d_d_e_other_neg   = f_d_d_e_other * ( kid_age > 23 )
gen f_d_e_o_own_pos 	= f_d_e_o_own * (kid_age <= 23)
gen f_d_e_o_own_neg 	= f_d_e_o_own * (kid_age > 23)
gen f_d_e_o_other_pos   = f_d_e_o_other * (kid_age <= 23)
gen f_d_e_o_other_neg   = f_d_e_o_other * (kid_age > 23)

* Generate gender cohort controls
forval c = 1980(1)1993 {
	gen e_o_own_cohort_`c' 	 = e_o_own * cohort_`c'
	gen e_d_own_cohort_`c' 	 = e_d_own * cohort_`c'
	gen e_o_other_cohort_`c' = e_o_other * cohort_`c'
	gen e_d_other_cohort_`c' = e_d_other * cohort_`c'
}

* Variable prep part 2
gen e_d_own_neg	    = e_d_own * (kid_age > 23)
gen e_d_own_pos	    = e_d_own * (kid_age <= 23)
gen e_d_other_neg	= e_d_other * (kid_age > 23)
gen e_d_other_pos	= e_d_other * (kid_age <= 23)
gen e_o_own_neg	    = e_o_own * (kid_age > 23)
gen e_o_own_pos 	= e_o_own * (kid_age <= 23)
gen e_o_other_pos   = e_o_other * (kid_age > 23)
gen e_o_other_neg	= e_o_other * (kid_age <= 23)
gen d_e_own_pos	    = d_e_own * (kid_age > 23)
gen d_e_own_neg	    = d_e_own * (kid_age <= 23)
gen d_e_other_pos	= d_e_other * (kid_age > 23)
gen d_e_other_neg	= d_e_other * (kid_age <= 23)

* Generate siblings count total and by gender for column 6 of table IV
egen n_sibs_tot 	= count(fam_id) if insample == 1 &age_outcome== 24 , by(fam_id) 
egen n_sibs_sg		= count(fam_id) if insample == 1 &age_outcome== 24 , by(fam_id male) 

* Define cohort-gender interaction control lists
global cohort_controls_gender_own 		cohort_* e_o_own_cohort_* e_d_own_cohort_*
global cohort_controls_gender_other 	cohort_* e_o_other_cohort_* e_d_other_cohort_*
global cohort_controls_gender 			cohort_* e_o_own_cohort_* e_d_own_cohort_* e_o_other_cohort_* e_d_other_cohort_* 

* Parametric Hockey Stick
global gender_e_d_own		= "f_d_d_e_own_pos   f_d_d_e_own_neg   d_e_own_pos   d_e_own_neg "
global gender_e_d_other 	= "f_d_d_e_other_pos f_d_d_e_other_neg d_e_other_pos d_e_other_neg "
global gender_e_o_own 		= "e_o_own "
global gender_e_o_other 	= "e_o_other " 
global gender_controls 		= "f_d_dummy_* par_rank_n_dummy_* "

* Column 1
eststo gender_cc_ownonly:  		 reg  kid_rank $gender_e_d_own 		$gender_e_o_own 										$gender_controls ${cohort_controls_gender_own} 	if insample == 1 &age_outcome == 24, $se 
* Column 2 -- replace own gender predictions w/ other gender predictions
eststo gender_cc_otheronly:   	 reg  kid_rank $gender_e_d_other 	$gender_e_o_other 										$gender_controls ${cohort_controls_gender_own} 	if insample == 1 &age_outcome == 24, $se 
* Column 3 -- combine Column 1 + 2
eststo gender_cc_both:   		 reg  kid_rank $gender_e_d_own 		$gender_e_d_other 	$gender_e_o_own $gender_e_o_other 	$gender_controls ${cohort_controls_gender_own} 	if insample == 1 &age_outcome == 24, $se 
* Column 4 -- Add family fixed effects to columns 1-3
eststo gender_cc_ownonly_fam:    areg kid_rank $gender_e_d_own 		$gender_e_o_own 										$gender_controls ${cohort_controls_gender_own} 	if insample == 1 &age_outcome == 24, a(fam_age_fx) $se 
* Column 5
eststo gender_cc_otheronly_fam:  areg kid_rank $gender_e_d_other 	$gender_e_o_other 										$gender_controls ${cohort_controls_gender_own} 	if insample == 1 &age_outcome == 24, a(fam_age_fx) $se 
* Column 6
eststo gender_cc_both_fam:  	 areg kid_rank $gender_e_d_own 		$gender_e_d_other 	$gender_e_o_own $gender_e_o_other 	$gender_controls ${cohort_controls_gender_own} 	if insample == 1 &age_outcome == 24, a(fam_age_fx) $se 
* Column 7 
eststo gender_cc_both_fam2g:   	 areg kid_rank $gender_e_d_own 		$gender_e_d_other $gender_e_o_own $gender_e_o_other 	$gender_controls ${cohort_controls_gender_own}  if insample == 1 &age_outcome== 24 & n_sibs_sg < n_sibs_tot, a(fam_age_fx) $se 

esttab using ../results/${filename}_table4.csv,  se nostar nodepvar replace
eststo clear

*-------------------------------------------------------------------------------
* Appendix Table II - Sensitivity to Population and Distance Restrictions
*-------------------------------------------------------------------------------

use ../intermediate/cz_intermediate_data.dta, clear

* Column 1
_eststo rstrctp_base: 				reg kid_rank $regvars_pooled ${cohort_controls_age24} if insample == 1 							  & age_outcome == 24 & !mi(miles) 
* Column 2
_eststo rstrctp_pop50k_nomiles: 	reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>5e4&pop_d>5e4 					  & age_outcome == 24 & !mi(miles)
* Columm 3
_eststo rstrctp_nodist: 			reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>2.5e5&pop_d>2.5e5 				  & age_outcome == 24 & !mi(miles)
* Column 4
_eststo rstrctp_pop500k_nomiles: 	reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>5e5&pop_d>5e5 					  & age_outcome == 24 & !mi(miles)
* Column 5
_eststo rstrctp_pop50k_100miles: 	reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>5e4&pop_d>5e4 		& miles > 100 & age_outcome == 24 & !mi(miles)
* Column 6
_eststo rstrctp_pop250k_100miles: 	reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>2.5e5&pop_d>2.5e5 	& miles > 100 & age_outcome == 24 & !mi(miles)
* Column 7
_eststo rstrctp_pop500k_100miles: 	reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>5e5&pop_d>5e5 		& miles > 100 & age_outcome == 24 & !mi(miles)
* Column 8
_eststo rstrctp_pop50k_200miles: 	reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>5e4&pop_d>5e4 		& miles > 200 & age_outcome == 24 & !mi(miles)
* Column 9
_eststo rstrctp_pop250k_200miles: 	reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>2.5e5&pop_d>2.5e5  	& miles > 200 & age_outcome == 24 & !mi(miles)
* Column 10
_eststo rstrctp_pop500k_200miles: 	reg kid_rank $regvars_pooled ${cohort_controls_age24} if pop_o>5e5&pop_d>5e5 		& miles > 200 & age_outcome == 24 & !mi(miles)

esttab using ../results/${filename}_appendix_table2.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Appendix Table III - Heterogeneity in Exposure Effects Across Subgroups
*-------------------------------------------------------------------------------

* Merge on cz-age-cohort place effects
clonevar cz = par_cz_orig 
merge m:1 cz cohort age_outcome using movers_v10s_peczcohort.dta, keepusing(cz age_outcome i_kr s_kr) nogen assert(2 3) keep(1 3)
gen e_o50 = i_kr+.5*s_kr
drop cz i_kr s_kr

clonevar cz = par_cz_dest 
merge m:1 cz cohort age_outcome using movers_v10s_peczcohort.dta, keepusing(cz age_outcome i_kr s_kr) nogen assert(2 3) keep(1 3)
gen e_d50 = i_kr+.5*s_kr
drop cz i_kr s_kr

* Make vars
gen d_e50         = e_d50 - e_o50
gen f_d_d_e50_pos = (kid_age <= 23) * f_d * d_e50
gen f_d_d_e50_neg = (kid_age > 23) * f_d * d_e50
gen d_e50_pos     = (kid_age <= 23) * d_e50
gen d_e50_neg     = (kid_age > 23) * d_e50

global p50con = " f_d_d_e50_pos f_d_d_e50_neg d_e50_pos d_e50_neg e_o50 "

* Column 1
_eststo hetero_cc_base:    reg kid_rank $regvars_full ${cohort_controls_age24} if insample == 1 & age_outcome == 24, $se 
* Column 2
_eststo hetero_cc_rich:    reg kid_rank $regvars_full ${cohort_controls_age24} if insample == 1 & age_outcome == 24 & par_rank_n >= .5, $se 
* Column 3
_eststo hetero_cc_poor:    reg kid_rank $regvars_full ${cohort_controls_age24} if insample == 1 & age_outcome == 24 & par_rank_n < .5, $se 
* Column 4
_eststo hetero_cc_pos: 	   reg kid_rank $regvars_full ${cohort_controls_age24} if insample == 1 & age_outcome == 24 & d_e >= 0 ,m$se 
* Column 5
_eststo hetero_cc_neg: 	   reg kid_rank $regvars_full ${cohort_controls_age24} if insample == 1 & age_outcome == 24 & d_e < 0, $se 

esttab using ../results/${filename}_appendix_table3.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*-------------------------------------------------------------------------------
* Appendix Table VI - Family FEs Estimates: Sensitivity to Cohort Controls & Pop Restrictions
*-------------------------------------------------------------------------------

use ../intermediate/cz_intermediate_data.dta, clear

* Column 1 Panel A
_eststo robust_pool_cc_insample: 	reg kid_rank ${regvars_pooled} ${cohort_controls_age24} if insample==1 & age_outcome == 24, $se 
* Column 2 Panel A
_eststo robust_pfam_cc_insample: 	reg kid_rank ${regvars_pooled} ${cohort_controls_age24} if insample==1 & age_outcome == 24, absorb(fam_age_fx) $se 
* Column 3 Panel A
_eststo robust_pool_cc_p`pop'_d100: reg kid_rank ${regvars_pooled} ${cohort_controls_age24} if pop_o>50000 & pop_d>50000 & miles>100 & age_outcome == 24 & !missing(miles), $se 
* Column 4 Panel A
_eststo robust_pfam_cc_p`pop'_d100: reg kid_rank ${regvars_pooled} ${cohort_controls_age24} if pop_o>50000 & pop_d>50000 & miles>100 & age_outcome == 24 & !missing(miles), absorb(fam_age_fx) $se 

* Column 1 Panel B
_eststo robust_pool_insample: 	 reg kid_rank ${regvars_pooled} if insample==1 & age_outcome == 24, $se 
* Column 2 Panel B
_eststo robust_pfam_insample: 	 reg kid_rank ${regvars_pooled} if insample==1 & age_outcome == 24, absorb(fam_age_fx) $se 
* Column 3 Panel B
_eststo robust_pool_p`pop'_d100: reg kid_rank ${regvars_pooled} if pop_o>50000 & pop_d>50000 & miles>100 & age_outcome == 24 & !missing(miles), $se 
* Column 4 Panel B
_eststo robust_pfam_p`pop'_d100: reg kid_rank ${regvars_pooled} if pop_o>50000 & pop_d>50000 & miles>100 & age_outcome == 24 & !missing(miles), absorb(fam_age_fx)$se 

esttab using ../results/${filename}_appendix_table6.csv, se nostar nodepvar replace substitute(`"""' `""' "=" "")
eststo clear

*===============================================================================
* End of code
*===============================================================================

log close ${filename}
