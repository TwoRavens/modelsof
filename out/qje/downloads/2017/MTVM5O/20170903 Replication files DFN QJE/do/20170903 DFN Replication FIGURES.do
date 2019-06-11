*JOPPE DE REE, SEPTEMBER 3 2017 (joppederee@gmail.com)
*version: Stata/MP 13.0 

clear
clear matrix
clear mata
set mem 1000m
set more off
set matsize 2000

global FOLDER "C:\20170903 Replication files DFN QJE"

global IN2 "$FOLDER\dta\REPLICATION"
global OUTPUT "$FOLDER\output"

*************************************************************************
*FIGURES
*************************************************************************

*figure -- bar graph, about how many teachers per year of quota
use "$IN2\teachers", replace

collapse certified PAID, by(year treatment)
reshape wide certified PAID, i(year) j(treatment)

*Fig IV.A
graph bar certified*, scheme(s1mono) over(year, relabel(1 "Y0" 2 "Y2" 3 "Y3")) legend(on order(1 "control" 2 "treatment" )) ylabel(0(0.2)0.8, angle(0)) 
graph export "$OUTPUT\certified.eps", replace
!epstopdf "$OUTPUT\certified.eps"

*Fig IV.B
graph bar PAID*, scheme(s1mono) over(year, relabel(1 "Y0" 2 "Y2" 3 "Y3")) legend(on order(1 "control" 2 "treatment" )) ylabel(0(0.2)0.8, angle(0)) 
graph export "$OUTPUT\paid.eps", replace
!epstopdf "$OUTPUT\paid.eps"

*Fig III
use "$IN2\teachers", clear

foreach X in 2006 2007 2008 2009 2010 2011 2012{
	gen cum_quota`X'=quota_year<=`X' if quota_year!=.
	replace cum_quota`X'=0 if interviewed==1&quota_year==.
	}

keep if interviewed==1
collapse cum_quota*, by(year treatment)
reshape long cum_quota, i(year treatment) j(cyear, string)
reshape wide cum_quota, i(year cyear) j(treatment)
foreach X in 0 1{
	replace cum_quota`X'=. if year==0&(cyear=="2010"|cyear=="2011"|cyear=="2012")
	replace cum_quota`X'=. if year==2&(cyear=="2012")
	}

keep if (year==0&(cyear=="2006"|cyear=="2007"|cyear=="2008"|cyear=="2009"))|(year==2&(cyear=="2010"|cyear=="2011"))|(year==3&(cyear=="2012"))
graph bar cum_quota*, scheme(s1mono) over(cyear) legend(on order(1 "control" 2 "treatment" )) ylabel(0(0.2)0.8, angle(0))
graph export "$OUTPUT\inquota.eps", replace
!epstopdf "$OUTPUT\inquota.eps"



*Fig 5 (nonparametric plots)

*Fig 5B and 5D

*number of iterations
local it = 1000

foreach W in "2 controls Y2 B" "3 controls Y3 D"{
tokenize `W'

use "$IN2\students.dta", clear

	keep if year==`1'
	drop year

	keep student_id school_id triplet_id subject testbook treatment ITT_score missing_schoolscore0 schoolscore0 
	tab triplet_id, gen(triplet)
	drop triplet_id
	
	*keep one score per year per student (average normalized score across subjects)
	gen mschoolscore0=schoolscore0
	collapse ITT_score mschoolscore0 missing_schoolscore0, by(student_id school_id treatment testbook triplet*)			//collapsing by student (across subjects)

	*renormalizing scores
	egen mITT_score_=mean(ITT_score) if treatment==0, by(testbook)
	egen mITT_score=max(mITT_score_), by(testbook)
	egen sdITT_score_=sd(ITT_score) if treatment==0, by(testbook)
	egen sdITT_score=max(sdITT_score_), by(testbook)
	replace ITT_score=(ITT_score-mITT_score)/sdITT_score
	drop mITT* sdITT*
	bys treatment: sum ITT_score
	
	*unexplained variation
	reg ITT_score triplet* mschoolscore0 missing_schoolscore0
	predict ITT_score_resid, resid
	
	drop triplet* missing_schoolscore0 mschoolscore0 testbook
	compress
	
	set seed 1234567890
	tempfile Figure5
	save `Figure5', replace
	******************************Bootstrapped Confidence Interval***************************************************
	
	qui egen kernel_range = fill(.01(.01)1)
	qui replace kernel_range = . if kernel_range>1				//variable used to store percentiles
	mkmat kernel_range if kernel_range != .						//making a matrix out of this variable
	matrix diff = kernel_range									//three the same matrices with different names: kernel_range, diff, x
	matrix x = kernel_range

	forvalues i = 1(1)`it'{
	di "Scores `3' " `i'

		***sampling 
		use `Figure5', clear		
		bsample, strata(treatment) cluster(school_id)					//sampling from cluster level data (stratified by treatment/control)

		*creating percentile rankings
		bysort treatment: egen rank = rank(ITT_score), unique		//JDR: ranking on outcome score, by treatment/control
		bysort treatment: egen max_rank = max(rank)							
		bysort treatment: gen percentile = rank/max_rank 					//scaling rank to percentiles

		drop max_rank rank
		
		egen kernel_range = fill(.01(.01)1)								//
		qui replace kernel_range = . if kernel_range>1					//variable used for points to evaluate the polynomial regression on the data (below)

		*regressing endline scores on percentile rankings
		lpoly ITT_score_resid percentile if treatment == 0 , gen(xcon_b2 `3'_con_b) at (kernel_range) nograph
		lpoly ITT_score_resid percentile if treatment == 1 , gen(xtre_b2 `3'_tre_b) at (kernel_range) nograph

		mkmat `3'_tre_b if `3'_tre_b != . 					//store the results (evaluated in kernel_range) in two matrices
		mkmat `3'_con_b if `3'_con_b != . 
		matrix diff = diff, `3'_tre_b - `3'_con_b			//the matrix "diff" is important because it stores the differences between treatment and control at different points

	}
	matrix diff = diff'

	*each variable is a percentile that is being estimated (can sort by column to get 2.5th and 97.5th confidence interval)
	svmat diff
	keep diff* 

	matrix conf_int = J(100, 2, 100)
	qui drop if _n == 1
	*sort each column (percentile) and saving 25th and 975th place in a matrix
	local bottom 	= ceil(2.5*`it'/100)
	local top 		= floor(97.5*`it'/100)
	forvalues i = 1(1)100{	
		sort diff`i'
		matrix conf_int[`i', 1] = diff`i'[`bottom']
		matrix conf_int[`i', 2] = diff`i'[`top']
	}

	*******************Graphs*************************************
	use `Figure5', clear 
	
	*y2 vs y0 graph: 
	*creates percentile for control students
		bysort treatment: egen rank = rank(ITT_score), unique
		bysort treatment: egen max_rank = max(rank)
		bysort treatment: gen percentile = rank/max_rank 
		
		drop max_rank rank
			
		egen kernel_range = fill(.01(.01)1)
		qui replace kernel_range = . if kernel_range>1

	lpoly ITT_score_resid percentile if treatment == 0 , gen(xcon_b2 `3'_con_b) at (kernel_range) nograph
	lpoly ITT_score_resid percentile if treatment == 1 , gen(xtre_b2 `3'_tre_b) at (kernel_range) nograph

	gen diff = `3'_tre_b - `3'_con_b

	*variables for confidence interval bands
	svmat conf_int			//estimated confidence band is added to the data

	graph twoway (line diff xcon_b2, lcolor(black) lwidth(medthick) lpattern(solid) legend(lab(1 "Treatment effect"))) ///
				(line conf_int1 xcon_b2, lcolor(black) lpattern(shortdash) legend(lab(2 "95% Confidence Band"))) ///
				(line conf_int2 xcon_b2, lcolor(black) lpattern(shortdash) legend(lab(3 "95% Confidence Band"))) ///
				,scheme(s1mono) yline(0, lcolor(gs10)) xtitle(Percentile of `3' Score) ytitle(Standardized `3' Score) legend(order(1 2)) ylabel(-0.3(0.1)0.3, angle(0)) title("`4'", position(11))
	graph export "$OUTPUT\np_`4'.eps", replace
	!epstopdf "$OUTPUT\np_`4'.eps"

}


*first stage effects, at quantiles of the outcome distribution
foreach W in "2 controls Y2 A" "3 controls Y3 C"{
tokenize `W'

use "$IN2\students.dta", clear

	gen cum_P=P2 if year==2								//number of full years with a certified teacher since Y0.
	replace cum_P=P2+P3 if year==3

	keep if year==`1'
	keep if cum_P!=.				
	count

	keep student_id school_id triplet_id subject testbook treatment ITT_score missing_schoolscore0 schoolscore0 cum_P
	tab triplet_id, gen(triplet)
	drop triplet_id

	gen mschoolscore0=schoolscore0
	collapse ITT_score mschoolscore0 missing_schoolscore0 cum_P, by(student_id school_id treatment testbook triplet*)			//collapsing across subjects

	*renormalizing 
	egen mITT_score_=mean(ITT_score) if treatment==0, by(testbook)
	egen mITT_score=max(mITT_score_), by(testbook)
	egen sdITT_score_=sd(ITT_score) if treatment==0, by(testbook)
	egen sdITT_score=max(sdITT_score_), by(testbook)
	replace ITT_score=(ITT_score-mITT_score)/sdITT_score
	drop mITT* sdITT*
	bys treatment: sum ITT_score
	
	*unexplained variation
	reg cum_P triplet* mschoolscore0 missing_schoolscore0
	predict cum_P_resid, resid
	egen m_cum_P=mean(cum_P)
	replace cum_P_resid=cum_P_resid+m_cum_P				//it is the residual PLUS the average outcome score, to keep the magnitudes right
	drop m_cum_P
	
	drop triplet* missing_schoolscore0 mschoolscore0 testbook
	compress
	
	set seed 1234567890
	tempfile Figure5
	save `Figure5', replace
	******************************Bootstrapped Confidence Interval***************************************************

	qui egen kernel_range = fill(.01(.01)1)
	qui replace kernel_range = . if kernel_range>1				//variable used to store percentiles
	mkmat kernel_range if kernel_range != .						//making a matrix out of this variable
	matrix diff = kernel_range									//three the same matrices with different names: kernel_range, diff, x
	matrix x = kernel_range

	forvalues i = 1(1)`it'{
	di "First stage `3' " `i'

		*sampling
		use `Figure5', clear
		bsample, strata(treatment) cluster(school_id)						//sampling from cluster level data (stratified by treatment/control)
	
		bysort treatment: egen rank = rank(ITT_score), unique				//ranking on outcome score, by treatment/control
		bysort treatment: egen max_rank = max(rank)							
		bysort treatment: gen percentile = rank/max_rank 					//scaling rank to percentiles

		drop max_rank rank
		
		egen kernel_range = fill(.01(.01)1)								
		qui replace kernel_range = . if kernel_range>1					//variable used for points to evaluate the polynomial regression on the data (below)

		*regressing endline scores on percentile rankings
		lpoly cum_P_resid percentile if treatment == 0 , gen(xcon_b2 `3'_con_b) at (kernel_range) nograph
		lpoly cum_P_resid percentile if treatment == 1 , gen(xtre_b2 `3'_tre_b) at (kernel_range) nograph

		mkmat `3'_tre_b if `3'_tre_b != . 					//store the results (evaluated in kernel_range) in two matrices
		mkmat `3'_con_b if `3'_con_b != . 
		matrix diff = diff, `3'_tre_b - `3'_con_b			//the matrix "diff" is important because it stores the differences between treatment and control at different points

	}	

	matrix diff = diff'

	*each variable is a percentile that is being estimated (can sort by column to get 2.5th and 97.5th confidence interval)
	svmat diff
	keep diff* 

	matrix conf_int = J(100, 2, 100)
	qui drop if _n == 1
	*sort each column (percentile) and saving 25th and 975th place in a matrix
	local bottom 	= ceil(2.5*`it'/100)
	local top 		= floor(97.5*`it'/100)
	forvalues i = 1(1)100{				//at each percentile, the value at the 2.5th and 97.5 percentile are kept for the confidence band
		sort diff`i'
		matrix conf_int[`i', 1] = diff`i'[`bottom']
		matrix conf_int[`i', 2] = diff`i'[`top']
	}

	*******************Graphs for control, treatment, and difference using actual data (BASELINE)*************************************
	use `Figure5', clear
	  
		bysort treatment: egen rank = rank(ITT_score), unique
		bysort treatment: egen max_rank = max(rank)
		bysort treatment: gen percentile = rank/max_rank 
		
		drop max_rank rank
			
		egen kernel_range = fill(.01(.01)1)
		qui replace kernel_range = . if kernel_range>1

	lpoly cum_P_resid percentile if treatment == 0 , gen(xcon_b2 `3'_con_b) at (kernel_range) nograph
	lpoly cum_P_resid percentile if treatment == 1 , gen(xtre_b2 `3'_tre_b) at (kernel_range) nograph

	gen diff = `3'_tre_b - `3'_con_b

	*variables for confidence interval bands
	svmat conf_int			//estimated confidence band is added to the data

	graph twoway (line diff xcon_b2, lcolor(black) lwidth(medthick) lpattern(solid) legend(lab(1 "Treatment effect"))) ///
				(line conf_int1 xcon_b2, lcolor(black) lpattern(shortdash) legend(lab(2 "95% Confidence Band"))) ///
				(line conf_int2 xcon_b2, lcolor(black) lpattern(shortdash) legend(lab(3 "95% Confidence Band"))) ///
				,scheme(s1mono) yline(0, lcolor(gs10)) xtitle(Percentile of `3' Score) ytitle(Years with a certified teacher from baseline to `3') legend(order(1 2)) ylabel(-0.6(0.2)0.6, angle(0)) title("`4'", position(11))
	graph export "$OUTPUT\np_`4'.eps", replace
	!epstopdf "$OUTPUT\np_`4'.eps"
	}
